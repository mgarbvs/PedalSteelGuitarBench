// node tests/test_input.js — runs InputSteel's generated gen~ code in Node with a synthetic input
// (a 220 Hz tone, as fzero~ would report it) and checks tuning, glides, release and headroom.
var assert = require("assert");
var path = require("path");
var G = require("./gen_shim.js"), SR = G.SR, pitchOf = G.pitchOf, rms = G.rms;

var code = G.loadCode(path.join(__dirname, "../m4l/InputSteel.maxpat"));
var DETUNE = [1.5, -1, 0.5, -1.5, 1, -0.5, 1.5, -1, 0.5, -1.5];

function engine(hz, level) {
    var e = new G.Engine(code), t = 0;
    e.set("inhz", hz); e.st.hzsm = hz; e.set("reverb", 0); e.set("vib", 0);
    e.play = function (sec) { // the input plays a harmonic-rich tone at hz
        var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n);
        for (var i = 0; i < n; i++, t++) {
            var ph = 2 * Math.PI * hz * t / SR;
            e.st.in1 = e.st.in2 = level * (0.6 * Math.sin(ph) + 0.25 * Math.sin(2 * ph) + 0.1 * Math.sin(3 * ph));
            e.tick(e.st); L[i] = e.st.out1; R[i] = e.st.out2;
        }
        return [L, R];
    };
    return e;
}
function pluck(e, s, p) { e.set("p" + s, p); e.set("d" + s, 0); e.set("v" + s, 0.8); e.set("k" + s, e.st["k" + s] + 1); }

// 1. Tuning: an A3 input played as each string's note, up and down, stays in tune.
[[9, 47], [3, 64], [0, 80], [5, 57]].forEach(function (c) {
    var e = engine(220, 1);
    pluck(e, c[0], c[1]);
    var cents = (pitchOf(e.play(0.6)[0].subarray(SR * 0.3)) - c[1] - DETUNE[c[0]] / 100) * 100;
    console.log("voice " + (c[0] + 1) + " note " + c[1] + ": " + cents.toFixed(2) + " cents");
    assert(Math.abs(cents) < 5, "out of tune");
});

// 2. Any input pitch: a C4 input plays the same note (the shift follows the tracked pitch).
var e = engine(261.63, 1);
pluck(e, 3, 64);
assert(Math.abs(pitchOf(e.play(0.6)[0].subarray(SR * 0.3)) - (64 + DETUNE[3] / 100)) < 0.05, "tracks input pitch");

// 3. Glide: a sounding voice follows a pedal bend (E4 → F#4 in 100 ms).
e = engine(220, 1);
pluck(e, 3, 64);
e.play(0.2);
e.set("g3", 100); e.set("p3", 66);
assert(Math.abs(pitchOf(e.play(0.5)[0].subarray(SR * 0.2)) - (66 + DETUNE[3] / 100)) < 0.05, "bend lands on F#");

// 4. Held note sustains as long as the input does; the level stays steady (the two taps don't beat).
e = engine(220, 1);
pluck(e, 3, 64);
var held = e.play(3)[0], lv = [];
for (var k = 0; k < 10; k++) lv.push(rms(held, SR * (0.3 + k * 0.25), SR * (0.4 + k * 0.25)));
console.log("held level min/max " + (Math.min.apply(0, lv) / Math.max.apply(0, lv)).toFixed(2));
assert(Math.min.apply(0, lv) > 0.8 * Math.max.apply(0, lv), "steady sustain");

// 5. Release: key up fades > 30 dB within 0.4 s. No keys: silent (Dry 0).
var before = rms(held, SR * 2.8, SR * 3);
e.set("d3", 1);
var drop = 20 * Math.log10(before / rms(e.play(0.5)[0], SR * 0.4, SR * 0.5));
console.log("release: -" + drop.toFixed(0) + " dB after 0.4 s");
assert(drop > 30, "releases");
e = engine(220, 1);
assert(rms(e.play(0.3)[0], 0, SR * 0.3) === 0, "silent with no keys");

// 6. Dry passes the input through untouched.
e = engine(220, 0.5);
e.set("dry", 1);
var d = e.play(0.3)[0];
assert(Math.abs(rms(d, SR * 0.2, SR * 0.3) - 0.5 * Math.sqrt((0.36 + 0.0625 + 0.01) / 2)) < 0.01, "dry level");

// 7. Full strum of a full-scale input stays under the limiter.
e = engine(220, 0.95);
[66, 63, 68, 64, 59, 56, 54, 52, 50, 47].forEach(function (p, s) { pluck(e, s, p); });
var lr = e.play(1), peak = 0;
for (var i = 0; i < lr[0].length; i++) { assert(isFinite(lr[0][i])); peak = Math.max(peak, Math.abs(lr[0][i]), Math.abs(lr[1][i])); }
console.log("10-voice strum peak " + peak.toFixed(2));
assert(peak < 0.95, "headroom");

// 8. No clicks while the input slides across 80–600 Hz (the shifter's window must follow the pitch smoothly).
e = engine(80, 1);
pluck(e, 3, 64);
var ph0 = 0, prev = 0, worst = 0;
for (i = 0; i < SR; i++) {
    var f = 80 * Math.pow(7.5, i / SR);
    ph0 += 2 * Math.PI * f / SR;
    e.set("inhz", f);
    e.st.in1 = e.st.in2 = 0.5 * Math.sin(ph0);
    e.tick(e.st);
    if (i > SR * 0.05) worst = Math.max(worst, Math.abs(e.st.out1 - prev));
    prev = e.st.out1;
}
console.log("slide max step " + worst.toFixed(3));
assert(worst < 0.1, "click during slide");

// 9. Every message the brain, knobs and fzero~ send is a Param here.
var params = {};
code.replace(/^Param (\w+)\(/gm, function (_, n) { params[n] = true; });
["vib", "volpedal", "blockall", "swell", "sustain", "tone", "reverb", "volume", "inhz", "dry"]
    .forEach(function (n) { assert(params[n], "missing Param " + n); });
for (var s = 0; s < 10; s++) "pgkvwd".split("").forEach(function (c) { assert(params[c + s], "missing Param " + c + s); });

console.log("input: all tests passed");
