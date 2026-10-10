// node tests/test_sampler.js — runs SampleSteel's generated gen~ code in Node with a synthetic sample
// (a 220 Hz tone = A3) and checks tuning, glides, looping, one-shot, release and the brain's messages.
var assert = require("assert");
var path = require("path");
var G = require("./gen_shim.js"), SR = G.SR, pitchOf = G.pitchOf, rms = G.rms;

var maxpat = path.join(__dirname, "../m4l/SampleSteel.maxpat");
var code = G.loadCode(maxpat);
var DETUNE = [1.5, -1, 0.5, -1.5, 1, -0.5, 1.5, -1, 0.5, -1.5];

function tone(sec, hz) { // a harmonic-rich tone, so pitch tracking locks on
    var x = new Float64Array(Math.round(sec * SR));
    for (var i = 0; i < x.length; i++) {
        var ph = 2 * Math.PI * hz * i / SR;
        x[i] = 0.6 * Math.sin(ph) + 0.25 * Math.sin(2 * ph) + 0.1 * Math.sin(3 * ph);
    }
    return x;
}
function engine(sampleSec) {
    var e = new G.Engine(code);
    e.st.smp = tone(sampleSec, 220);
    e.set("smpsr", SR); e.set("root", 57); e.set("reverb", 0); e.set("vib", 0);
    return e;
}
function pluck(e, s, p) { e.set("p" + s, p); e.set("d" + s, 0); e.set("v" + s, 0.8); e.set("k" + s, e.st["k" + s] + 1); }

// 1. Tuning: a 220 Hz sample with Root = A3 plays every string's note in tune.
[[9, 47], [3, 64], [0, 80]].forEach(function (c) {
    var e = engine(2);
    pluck(e, c[0], c[1]);
    var out = e.run(0.6)[0].subarray(SR * 0.3);
    var cents = (pitchOf(out) - c[1] - DETUNE[c[0]] / 100) * 100;
    console.log("voice " + (c[0] + 1) + " note " + c[1] + ": " + cents.toFixed(2) + " cents");
    assert(Math.abs(cents) < 4, "out of tune");
});

// 2. Fine: +50 cents raises the pitch half a semitone.
var e = engine(2);
e.set("fine", -50);   // sample treated as 50 cents flat of A3 → plays 50 cents sharp
pluck(e, 3, 64);
assert(Math.abs(pitchOf(e.run(0.6)[0].subarray(SR * 0.3)) - (64.5 + DETUNE[3] / 100)) < 0.04, "fine tunes");

// 3. Glide: a ringing voice follows a pedal bend (E4 → F#4 in 100 ms).
e = engine(2);
pluck(e, 3, 64);
e.run(0.2);
e.set("g3", 100); e.set("p3", 66);
assert(Math.abs(pitchOf(e.run(0.5)[0].subarray(SR * 0.2)) - (66 + DETUNE[3] / 100)) < 0.04, "bend lands on F#");

// 4. Loop: a 0.5 s sample held for 3 s keeps sounding (Sustain fully up = no fade); one-shot stops.
e = engine(0.5);
pluck(e, 3, 57);   // root note: plays the sample at its own speed
var held = e.run(3)[0];
var early = rms(held, SR * 0.1, SR * 0.3), late = rms(held, SR * 2.7, SR * 3);
console.log("loop: late/early level " + (late / early).toFixed(2));
assert(late > 0.7 * early, "looped note sustains");
e = engine(0.5);
e.set("loop", 0);
pluck(e, 3, 57);
var once = e.run(1)[0];
assert(rms(once, SR * 0.6, SR * 1) < 1e-6, "one-shot ends with the sample");

// 5. Loop seam: no click. The loop starts at a waveform peak (33.25 cycles in) and is 66.5 cycles long,
// so the seam joins opposite peaks: a hard wrap jumps by ~2x the amplitude (~20x the tone's biggest
// step). The crossfade keeps every step within the tone's own.
e = engine(0.5);
var cyc = (SR / 220) / (0.5 * SR);   // one cycle as a fraction of the sample
e.set("lstart", 33.25 * cyc); e.set("lend", (33.25 + 66.5) * cyc);
pluck(e, 3, 57);
var x = e.run(2)[0], maxStep = 0, toneStep = 0;
for (var i = 1; i < x.length; i++) maxStep = Math.max(maxStep, Math.abs(x[i] - x[i - 1]));
for (i = SR * 0.1 + 1; i < SR * 0.2; i++) toneStep = Math.max(toneStep, Math.abs(x[i] - x[i - 1]));
console.log("loop seam: max step " + (maxStep / toneStep).toFixed(2) + "x the tone's own");
assert(maxStep < 1.3 * toneStep, "loop seam clicks");

// 6. Release: key up fades > 30 dB within 0.4 s.
e = engine(2);
pluck(e, 3, 64);
var before = rms(e.run(0.3)[0], SR * 0.2, SR * 0.3);
e.set("d3", 1);
var drop = 20 * Math.log10(before / rms(e.run(0.5)[0], SR * 0.4, SR * 0.5));
console.log("release: -" + drop.toFixed(0) + " dB after 0.4 s");
assert(drop > 30, "releases");

// 7. No sample loaded (gen~'s unbound Buffer has 1 sample): silent, never NaN.
e = new G.Engine(code);
pluck(e, 3, 64);
var empty = e.run(0.5)[0];
for (i = 0; i < empty.length; i++) assert(empty[i] === 0, "silent without a sample");

// 8. Full strum of a full-scale sample stays under the limiter.
e = engine(2);
e.st.smp = e.st.smp.map(function (v) { return v / 0.95; });
[66, 63, 68, 64, 59, 56, 54, 52, 50, 47].forEach(function (p, s) { pluck(e, s, p); });
var lr = e.run(1), peak = 0;
for (i = 0; i < lr[0].length; i++) { assert(isFinite(lr[0][i])); peak = Math.max(peak, Math.abs(lr[0][i]), Math.abs(lr[1][i])); }
console.log("10-voice strum peak " + peak.toFixed(2));
assert(peak < 0.95, "headroom");

// 9. Every message the brain and the knobs send is a Param here (else gen~ says "doesn't understand").
var params = {};
code.replace(/^Param (\w+)\(/gm, function (_, n) { params[n] = true; });
["vib", "volpedal", "blockall", "swell", "sustain", "tone", "reverb", "volume",
 "root", "fine", "loop", "lstart", "lend", "smpsr"].forEach(function (n) { assert(params[n], "missing Param " + n); });
for (var s = 0; s < 10; s++) "pgkvwd".split("").forEach(function (c) { assert(params[c + s], "missing Param " + c + s); });

console.log("sampler: all tests passed");
