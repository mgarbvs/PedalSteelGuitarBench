// node tests/test_engine.js [out.wav] — runs the real generated gen~ codebox in Node
// through a tiny GenExpr→JS shim, then checks tuning, glides, stability and damping.
// With a path argument it also renders a short demo (brain → engine) to a WAV file.
var assert = require("assert");
var fs = require("fs");
var path = require("path");

var G = require("./gen_shim.js"), SR = G.SR, pitchOf = G.pitchOf, rms = G.rms;
var code = G.loadCode(path.join(__dirname, "../m4l/PedalSteel.maxpat"));
function Engine() { G.Engine.call(this, code); }
Engine.prototype = G.Engine.prototype;

function pluck(e, s, p) { e.set("p" + s, p); e.set("d" + s, 0); e.set("v" + s, 0.8); e.set("k" + s, e.st["k" + s] + 1); }

var DETUNE = [1.5, -1, 0.5, -1.5, 1, -0.5, 1.5, -1, 0.5, -1.5];

// 1. Tuning: every string, low to high, lands within 4 cents of its note.
[[9, 47], [3, 64], [0, 80], [2, 90]].forEach(function (c) {
    var e = new Engine();
    e.set("reverb", 0); e.set("vib", 0);
    pluck(e, c[0], c[1]);
    var out = e.run(0.6)[0].subarray(SR * 0.3);
    var cents = (pitchOf(out) - c[1] - DETUNE[c[0]] / 100) * 100;
    console.log("string " + (c[0] + 1) + " note " + c[1] + ": " + cents.toFixed(2) + " cents");
    assert(Math.abs(cents) < 4, "out of tune");
});

// 2. Glide: a ringing string follows a pedal bend (E4 → F#4 in 100 ms).
var e = new Engine();
e.set("reverb", 0); e.set("vib", 0);
pluck(e, 3, 64);
e.run(0.2);
e.set("g3", 100); e.set("p3", 66);
var bent = e.run(0.5)[0].subarray(SR * 0.2);
assert(Math.abs(pitchOf(bent) - (66 + DETUNE[3] / 100)) < 0.04, "bend lands on F#");

// 3. Stability: all ten strings, longest sustain, brightest tone, full reverb.
e = new Engine();
e.set("sustain", 20000); e.set("tone", 100); e.set("reverb", 100); e.set("vib", 1);
for (var s = 0; s < 10; s++) pluck(e, s, [66, 63, 68, 64, 59, 56, 54, 52, 50, 47][s]);
var lr = e.run(3), peak = 0;
for (var i = 0; i < lr[0].length; i++) { assert(isFinite(lr[0][i]) && isFinite(lr[1][i])); peak = Math.max(peak, Math.abs(lr[0][i]), Math.abs(lr[1][i])); }
assert(rms(lr[0], SR * 2.5, SR * 3) < rms(lr[0], SR * 0.2, SR * 0.7), "decays");
console.log("10-string strum peak " + peak.toFixed(2));
assert(peak < 0.95, "headroom");

// 4. Lifting the last key damps the string and palm-blocks the rest (> 30 dB within 0.4 s).
e = new Engine();
e.set("reverb", 0);
pluck(e, 3, 64);
var before = rms(e.run(0.3)[0], SR * 0.2, SR * 0.3);
e.set("d3", 1); e.set("blockall", 1);
var after = e.run(0.5)[0];
var drop = 20 * Math.log10(before / rms(after, SR * 0.4, SR * 0.5));
console.log("damp: -" + drop.toFixed(0) + " dB after 0.4 s");
assert(drop > 30, "damps");

// 5. Swell: with a slow swell the first 50 ms are much quieter than the note body.
e = new Engine();
e.set("reverb", 0); e.set("swell", 800);
pluck(e, 3, 64);
var sw = e.run(1)[0];
assert(rms(sw, 0, SR * 0.05) < 0.1 * rms(sw, SR * 0.8, SR * 0.9), "swells in");

// 6. Spring reverb: full strum at reverb=100 stays finite and under the limiter, and the reverb's
// own tail (isolated by damping every string right after the strum) decays instead of running away.
e = new Engine();
e.set("reverb", 100); e.set("sustain", 3000); e.set("tone", 60); e.set("vib", 1);
[66, 63, 68, 64, 59, 56, 54, 52, 50, 47].forEach(function (p, s) { pluck(e, s, p); });
e.run(0.3);
for (s = 0; s < 10; s++) e.set("d" + s, 1);   // damp every string; only the reverb loop keeps ringing
var tail = e.run(3), tpeak = 0, tfinite = true;
for (i = 0; i < tail[0].length; i++) {
    if (!isFinite(tail[0][i]) || !isFinite(tail[1][i])) tfinite = false;
    tpeak = Math.max(tpeak, Math.abs(tail[0][i]), Math.abs(tail[1][i]));
}
assert(tfinite, "reverb tail finite");
console.log("reverb tail peak " + tpeak.toFixed(3));
assert(tpeak < 0.95, "reverb tail headroom");
var revEarly = rms(tail[0], 0, SR * 0.1), revLate = rms(tail[0], SR * 2.5, SR * 3);
console.log("reverb tail rms: early " + revEarly.toFixed(4) + " late " + revLate.toExponential(2));
assert(revLate < revEarly * 0.1, "reverb tail decays");
var revMid = rms(tail[0], SR * 0.9, SR * 1.0);   // a spring tank still rings at 1 s (~2 s to -60 dB)
assert(revMid > revEarly * 0.003, "reverb tail is spring-length, not a sub-ms loop");

// 7. Sympathetic resonance: string 1 (F#4) rings; string 7 (F#3, same pitch class, never plucked,
// open) picks up energy through the shared bus; a palm block silences it; nothing runs away.
e = new Engine();
e.set("sustain", 8000); e.set("reverb", 0);
pluck(e, 0, 66);
e.run(1.5);
var sym = 0;
for (i = 0; i < 200; i++) { e.run(0.001); sym = Math.max(sym, Math.abs(e.st.lp6)); }
console.log("sympathetic pickup on string 7: " + sym.toExponential(2));
assert(sym > 1e-4, "open same-pitch-class string picks up energy");
e.set("d0", 1); e.set("blockall", 1);
e.run(0.5);
assert(Math.abs(e.st.lp6) < sym * 0.01, "palm block silences sympathetic ringing");
// worst case: all ten strings open, longest sustain, brightest tone, full strum, 10 s
e = new Engine();
e.set("sustain", 30000); e.set("tone", 100); e.set("reverb", 100);
[66, 63, 68, 64, 59, 56, 54, 52, 50, 47].forEach(function (p, s) { pluck(e, s, p); });
var early = rms(e.run(1)[0], 0, SR), more = e.run(9)[0], stable = true, peak10 = 0;
for (i = 0; i < more.length; i++) { if (!isFinite(more[i])) stable = false; peak10 = Math.max(peak10, Math.abs(more[i])); }
assert(stable && peak10 < 1, "coupling stays bounded with every string open");
assert(rms(more, SR * 8, SR * 9) < early, "and still decays");

// MPE: pressure (x) scales a string's level, slide (t) tilts its brightness; defaults are flat.
function mpeRun(x, t) {
    var e = new Engine();
    e.set("reverb", 0); e.set("vib", 0); e.set("x3", x); e.set("t3", t);
    pluck(e, 3, 64);
    var o = e.run(0.4)[0].subarray(SR * 0.1);
    var hi = new Float32Array(o.length - 1);
    for (var j = 1; j < o.length; j++) hi[j - 1] = o[j] - o[j - 1];   // first difference: high-band energy
    return { lvl: rms(o, 0, o.length), bright: rms(hi, 0, hi.length) / rms(o, 0, o.length) };
}
var flat = mpeRun(1, 0.5), soft = mpeRun(0.35, 0.5), dark = mpeRun(1, 0), bright = mpeRun(1, 1);
console.log("mpe: soft " + (soft.lvl / flat.lvl).toFixed(2) + "x level, brightness dark/flat/bright " +
            [dark, flat, bright].map(function (r) { return r.bright.toFixed(3); }).join("/"));
assert(Math.abs(soft.lvl / flat.lvl - 0.35) < 0.05, "pressure scales level");
assert(dark.bright < flat.bright && flat.bright < bright.bright, "slide tilts brightness");

// Pickup comb: string 4 (open 64) has its first notch at 14 * 329.63 Hz = 4615 Hz, the 7th harmonic of note 76.
function harm(x, hz) { // Hann-windowed, so the fundamental does not leak into the notch
    var re = 0, im = 0; for (var j = 0; j < x.length; j++) { var w = x[j] * (0.5 - 0.5 * Math.cos(2 * Math.PI * j / x.length)); re += w * Math.cos(2 * Math.PI * hz * j / SR); im += w * Math.sin(2 * Math.PI * hz * j / SR); } return Math.sqrt(re * re + im * im) / x.length; }
var pe = new Engine();
pluck(pe, 3, 76); pe.set("reverb", 0); pe.set("vib", 0);
var pk = pe.run(0.6)[0].subarray(SR * 0.1), pf = 440 * Math.pow(2, (76 - 1.5 / 100 - 69) / 12);
var h6 = harm(pk, 6 * pf), h7 = harm(pk, 7 * pf), h8 = harm(pk, 8 * pf);
var notchDb = 20 * Math.log10(h7 / ((h6 + h8) / 2));
console.log("pickup comb: 7th harmonic " + notchDb.toFixed(1) + " dB vs 6th/8th average");
assert(h7 < 0.25 * (h6 + h8) / 2, "pickup comb notch at 7th harmonic");

// Pick position: string 4 is plucked 0.2 of the way from the bridge, so its 5th harmonic has a node there.
var ppe = new Engine();
pluck(ppe, 3, 64); ppe.set("reverb", 0); ppe.set("vib", 0);
var ppk = ppe.run(0.3)[0].subarray(SR * 0.02), ppf = 440 * Math.pow(2, (64 - 1.5 / 100 - 69) / 12);
var ph4 = harm(ppk, 4 * ppf), ph5 = harm(ppk, 5 * ppf), ph6 = harm(ppk, 6 * ppf);
var pickDb = 20 * Math.log10(ph5 / ((ph4 + ph6) / 2));
console.log("pick position: 5th harmonic " + pickDb.toFixed(1) + " dB vs 4th/6th average");
assert(ph5 < 0.316 * (ph4 + ph6) / 2, "pick position node at 5th harmonic");

console.log("engine: all tests passed");

// Optional demo: E major → legato A major (pedal bend) → slide up to fret 3, through the brain.
if (process.argv[2]) {
    var msgs = [];
    global.outlet = function (o) { if (o === 0) msgs.push([arguments[1], arguments[2]]); };
    global.Task = function (fn) { this.fn = fn; this.schedule = function () { tasks.push(fn); }; };
    var tasks = [];
    var B = require("../m4l/steel_brain.js");
    e = new Engine();
    var chunks = [];
    function feed() { msgs.forEach(function (m) { e.set(m[0], m[1]); }); msgs = []; }
    function go(sec) { feed(); var r = e.run(sec); chunks.push(r); }
    function fire() { while (tasks.length) tasks.shift()(); }
    B.init(); feed();
    [59, 64, 68].forEach(function (n) { B.note(n, 100); }); fire(); go(1.2);
    [61, 69].forEach(function (n) { B.note(n, 100); }); B.noteoff(59); B.noteoff(68); fire(); go(1.4);
    [64, 69, 73].forEach(function (n) { B.note(n + 3, 100); }); [61, 64, 69].forEach(function (n) { B.noteoff(n); }); fire(); go(2.5);
    [64, 69, 73].forEach(function (n) { B.noteoff(n + 3); }); go(1.5);
    var total = chunks.reduce(function (a, c) { return a + c[0].length; }, 0);
    var buf = Buffer.alloc(44 + total * 4), off = 44;
    chunks.forEach(function (c) {
        for (var i = 0; i < c[0].length; i++) {
            buf.writeInt16LE(Math.round(c[0][i] * 32767), off); buf.writeInt16LE(Math.round(c[1][i] * 32767), off + 2); off += 4;
        }
    });
    buf.write("RIFF", 0); buf.writeUInt32LE(36 + total * 4, 4); buf.write("WAVEfmt ", 8);
    buf.writeUInt32LE(16, 16); buf.writeUInt16LE(1, 20); buf.writeUInt16LE(2, 22); buf.writeUInt32LE(SR, 24);
    buf.writeUInt32LE(SR * 4, 28); buf.writeUInt16LE(4, 32); buf.writeUInt16LE(16, 34);
    buf.write("data", 36); buf.writeUInt32LE(total * 4, 40);
    fs.writeFileSync(process.argv[2], buf);
    console.log("wrote " + process.argv[2]);
}
