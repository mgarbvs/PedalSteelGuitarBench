// node tests/test_brain.js — exits non-zero on the first failure.
var assert = require("assert");

var out = [], tasks = [];
global.outlet = function () { out.push(Array.prototype.slice.call(arguments)); };
global.Task = function (fn) { this.fn = fn; this.schedule = function () { if (tasks.indexOf(this) < 0) tasks.push(this); }; };
global.post = function () {};
var B = require("../m4l/steel_brain.js");

function flush() { while (tasks.length) tasks.shift().fn(); }
function fresh() { B.reset(); out = []; tasks = []; }
function plucks() { return out.filter(function (m) { return m[0] === 1 && m[1] === "pluck"; }); }
function sounding(n) { // is MIDI note n ringing on some string at its exact pitch?
    for (var s = 0; s < 10; s++) if (B.S.str[s].note === n && Math.abs(B.target(s) + B.S.str[s].pre - n) < 0.05) return true;
    return false;
}
function play(notes, vel) { notes.forEach(function (n) { B.note(n, vel || 100); }); flush(); }

// 1. E major at the nut: no pedals, 3 strings picked.
fresh();
play([59, 64, 68]);
assert.strictEqual(B.S.bar, 0);
assert.strictEqual(B.S.auto, 0);
assert.strictEqual(plucks().length, 3);
[59, 64, 68].forEach(function (n) { assert(sounding(n), "E major note " + n); });

// 2. Hold E major, move legato to A major (A4 + C#4 over the held E4): the
//    signature A+B pedal bend — ringing strings bend, nothing is re-picked.
out = [];
B.noteoff(59); B.noteoff(68);
play([61, 69]);
assert.strictEqual(B.S.bar, 0, "stays at the nut");
assert.strictEqual(B.S.auto, 1 | 2, "A+B pedals");
assert.strictEqual(plucks().length, 0, "legato bend, no re-pick");
[61, 64, 69].forEach(function (n) { assert(sounding(n), "A major note " + n); });

// 2b. The same change 5 s later (past 1/3 of the 12 s Sustain): the faded strings are re-picked as they bend.
fresh();
var clock = 0;
B.S.now = function () { return clock; };
play([59, 64, 68]);
clock = 5000;
out = [];
B.noteoff(59); B.noteoff(68);
play([61, 69]);
assert.strictEqual(plucks().length, 2, "re-picked while bending");
assert(out.some(function (m) { return m[1] === "g2" && m[2] > 0; }), "still glides, not snapped");
[61, 64, 69].forEach(function (n) { assert(sounding(n)); });

// 2c. ...but a chord held a normal length (1 s) just slides/bends, no re-pick.
fresh();
clock = 0;
B.S.now = function () { return clock; };
play([59, 64, 68]);
clock = 1000;
out = [];
[60, 65, 69].forEach(function (n) { B.note(n, 100); }); [59, 64, 68].forEach(function (n) { B.noteoff(n); }); flush();
assert.strictEqual(B.S.bar, 1, "slid up a fret");
assert.strictEqual(plucks().length, 0, "held strings slide without a re-pick");

// 2d. Re-striking the same notes right after release (staccato) is a new pick, not a 0-semitone slide.
fresh();
clock = 0;
B.S.now = function () { return clock; };
play([59, 64, 68]);
[59, 64, 68].forEach(function (n) { B.noteoff(n); }); flush();
clock = 30;
out = [];
play([59, 64, 68]);
assert.strictEqual(plucks().length, 3, "re-struck chord is re-picked");
fresh();
clock = 0;
B.S.now = function () { return clock; };
play([64]);
B.noteoff(64); flush();
clock += 30;
out = [];
play([64]);
assert.strictEqual(plucks().length, 1, "re-struck note is re-picked");

// 3. Every chord the player can throw at it sounds, with no wrong notes.
var seed = 1;
function rnd() { seed = (seed * 16807) % 2147483647; return seed / 2147483647; }
var fallbacks = 0;
for (var t = 0; t < 300; t++) {
    fresh();
    var size = 1 + Math.floor(rnd() * 4), chord = [];
    while (chord.length < size) {
        var n = 52 + Math.floor(rnd() * 24);
        if (chord.indexOf(n) < 0) chord.push(n);
    }
    play(chord);
    chord.forEach(function (n) { assert(sounding(n), "chord " + chord + " missing " + n); });
    for (var s = 0; s < 10; s++) if (B.S.str[s].offset) fallbacks++;
}
console.log("random chords: " + fallbacks + " behind-the-bar bends over 300 chords");

// 4. Major triads (steel grip B-E-G# shape) in all 12 keys land on the bar, no fallback.
for (var k = 0; k < 12; k++) {
    fresh();
    play([59 + k, 64 + k, 68 + k]);
    assert.strictEqual(B.S.bar, k, "triad " + k + " at fret " + k);
    for (var s2 = 0; s2 < 10; s2++) assert.strictEqual(B.S.str[s2].offset, 0);
}

// 5. Notes outside the steel's range fold into it.
fresh();
play([36]);
assert(sounding(48), "C2 folds up to C3");

// 6. Legato melody: E4 → F#4 is a C-pedal bend on the same string.
fresh();
play([64]);
out = [];
B.note(66, 100); flush(); B.noteoff(64);
assert.strictEqual(plucks().length, 0, "melody note bends in");
assert(sounding(66));

// 7. Bend-in "cry": detached chord needing pedals is picked low, then bent up.
fresh();
B.bendin(100);
[61, 64, 69].forEach(function (n) { B.note(n, 100); });
tasks.shift().fn(); // run the chord window only, not the pending bend
assert.strictEqual(B.S.auto, 1 | 2, "A major on the E9 grip = A+B pedals");
var bent = B.S.str.filter(function (x) { return x.pre > 0; }).length;
assert(bent > 0, "some strings start unpedaled");
B.applyBend();
[61, 64, 69].forEach(function (n) { assert(sounding(n)); });

// 8. Sustain pedal holds notes until it lifts.
fresh();
B.cc(64, 127);
play([64]);
B.noteoff(64);
assert(sounding(64), "sustained");
B.cc(64, 0);
assert(!sounding(64), "released with pedal");

// 9. Strings mode: C3 picks string 10, C2 holds pedal A (B → C#), pitch bend slides the bar.
fresh();
B.mode(1);
out = [];
B.note(48, 100);
assert.deepStrictEqual(plucks()[0].slice(0, 3), [1, "pluck", 10]);
assert.strictEqual(B.target(9), 47);
B.note(36, 100);
assert.strictEqual(B.target(9), 49);
B.noteoff(36);
assert.strictEqual(B.target(9), 47);
B.bar(3);
assert.strictEqual(B.target(9), 50);
B.bend(127);
assert(Math.abs(B.target(9) - 52) < 0.01);

// 9b. A latched pedal the chord actually bends is reported as 3 (bordered), an unused one as 2.
fresh();
function pedalsOut() { return out.filter(function (m) { return m[1][0] === "pedals"; }).pop()[1]; }
B.pedal("B", 1);
play([61, 64, 69]); // A major at the nut: B raises G# → A
var ped = pedalsOut();
assert.strictEqual(ped[2], 3, "latched B used by A major");
B.pedal("LKR", 1);
ped = pedalsOut();
assert.strictEqual(ped[5], 2, "freshly latched LKR not yet used");
B.pedal("B", 0);
ped = pedalsOut();
assert.strictEqual(ped[2], 0, "released B is off");

// 9c. Cabinet drop: A+B flatten the unpulled strings slightly; pulled strings stay in tune.
fresh();
B.pedal("A", 1); B.pedal("B", 1);
assert(B.target(3) < 64 && B.target(3) > 63.9, "string 4 (E) sags with A+B down");
assert.strictEqual(B.target(4), 61, "string 5 raised by A is exact");
B.pedal("A", 0); B.pedal("B", 0);
assert.strictEqual(B.target(3), 64, "no pedals, no drop");

// 10. Gen messages are well formed: name + number.
out.forEach(function (m) {
    if (m[0] !== 0) return;
    assert(/^([pgvwkd]\d|vib|volpedal|blockall)$/.test(m[1]), "bad gen message " + m[1]);
    assert(typeof m[2] === "number" && isFinite(m[2]), "bad value " + m);
});

console.log("steel_brain: all tests passed");
