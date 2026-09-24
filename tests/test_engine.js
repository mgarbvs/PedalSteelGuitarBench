// node tests/test_engine.js [out.wav] — runs the real generated gen~ codebox in Node
// through a tiny GenExpr→JS shim, then checks tuning, glides, stability and damping.
// With a path argument it also renders a short demo (brain → engine) to a WAV file.
var assert = require("assert");
var fs = require("fs");
var path = require("path");

var SR = 48000;
var maxpat = JSON.parse(fs.readFileSync(path.join(__dirname, "../m4l/PedalSteel.maxpat"), "utf8"));
var code = maxpat.patcher.boxes.filter(function (b) { return b.box.text === "gen~"; })[0]
    .box.patcher.boxes.filter(function (b) { return b.box.maxclass === "codebox"; })[0].box.code;

function Delay(n) { this.buf = new Float64Array(n); this.i = 0; }
Delay.prototype.write = function (x) { this.buf[this.i] = x; this.i = (this.i + 1) % this.buf.length; };
Delay.prototype.read = function (t) { // cubic (Catmull-Rom); t samples ago, t=1 = last write
    var n = this.buf.length, pos = this.i - t, i1 = Math.floor(pos), fr = pos - i1;
    function at(k) { return this.buf[((i1 + k) % n + n) % n]; }
    var y0 = at.call(this, -1), y1 = at.call(this, 0), y2 = at.call(this, 1), y3 = at.call(this, 2);
    return y1 + 0.5 * fr * (y2 - y0 + fr * (2 * y0 - 5 * y1 + 4 * y2 - y3 + fr * (3 * (y1 - y2) + y3 - y0)));
};

function Engine() {
    var st = this.st = {
        samplerate: SR, twopi: 2 * Math.PI, out1: 0, out2: 0,
        mtof: function (m) { return 440 * Math.pow(2, (m - 69) / 12); },
        clamp: function (x, a, b) { return Math.min(b, Math.max(a, x)); },
        wrap: function (x, a, b) { var r = b - a; return x - r * Math.floor((x - a) / r); },
        noise: function () { return Math.random() * 2 - 1; },
        dbtoa: function (d) { return Math.pow(10, d / 20); },
        min: Math.min, max: Math.max, sin: Math.sin, cos: Math.cos, exp: Math.exp, tanh: Math.tanh, atan2: Math.atan2
    };
    var body = [];
    code.split("\n").forEach(function (ln) {
        var m = ln.match(/^(Param|History|Delay) (\w+)\(([^)]*)\);$/);
        if (!m) return body.push(ln);
        st[m[2]] = m[1] === "Delay" ? new Delay(+m[3]) : +m[3];
    });
    // Every local becomes a state slot so `with` never leaks globals.
    (body.join("\n").match(/\b[a-zA-Z_]\w*\b/g) || []).forEach(function (id) { if (!(id in st)) st[id] = 0; });
    this.tick = new Function("st", "with (st) {" + body.join("\n").replace(/interp="cubic"/g, '"cubic"') + "}");
}
Engine.prototype.set = function (name, v) { assert(name in this.st, "no gen param " + name); this.st[name] = v; };
Engine.prototype.run = function (sec) {
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n);
    for (var i = 0; i < n; i++) { this.tick(this.st); L[i] = this.st.out1; R[i] = this.st.out2; }
    return [L, R];
};

function pitchOf(x) { // autocorrelation peak with parabolic refinement → MIDI pitch
    var best = 0, bestLag = 0, c = [];
    for (var lag = 20; lag < 1200; lag++) {
        var s = 0;
        for (var i = 0; i < 8000; i++) s += x[i] * x[i + lag];
        c[lag] = s;
    }
    for (lag = 21; lag < 1199; lag++) if (c[lag] > best && c[lag] > c[lag - 1] && c[lag] >= c[lag + 1]) { best = c[lag]; bestLag = lag; }
    // take the first peak close to the max (avoids octave errors)
    for (lag = 21; lag < bestLag; lag++) if (c[lag] > 0.9 * best && c[lag] > c[lag - 1] && c[lag] >= c[lag + 1]) { bestLag = lag; break; }
    var a = c[bestLag - 1], b = c[bestLag], d = c[bestLag + 1];
    var p = bestLag + 0.5 * (a - d) / (a - 2 * b + d);
    return 69 + 12 * Math.log2(SR / p / 440);
}
function rms(x, a, b) { var s = 0; for (var i = a; i < b; i++) s += x[i] * x[i]; return Math.sqrt(s / (b - a)); }
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

// 4. Releasing a key damps the string fast (> 30 dB within 0.4 s).
e = new Engine();
e.set("reverb", 0);
pluck(e, 3, 64);
var before = rms(e.run(0.3)[0], SR * 0.2, SR * 0.3);
e.set("d3", 1);
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
