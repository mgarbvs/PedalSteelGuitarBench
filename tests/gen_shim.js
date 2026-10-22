// gen_shim.js — runs a generated gen~ codebox in Node: Param/History/Delay/Buffer/Data become slots
// in a state object that the GenExpr body reads and writes. Shared by the engine tests.
var assert = require("assert");
var fs = require("fs");

var SR = 48000;

function loadCode(maxpatPath) {
    var maxpat = JSON.parse(fs.readFileSync(maxpatPath, "utf8"));
    return maxpat.patcher.boxes.filter(function (b) { return /^gen~/.test(b.box.text || ""); })[0]
        .box.patcher.boxes.filter(function (b) { return b.box.maxclass === "codebox"; })[0].box.code;
}

function cubic(y0, y1, y2, y3, fr) { // Catmull-Rom
    return y1 + 0.5 * fr * (y2 - y0 + fr * (2 * y0 - 5 * y1 + 4 * y2 - y3 + fr * (3 * (y1 - y2) + y3 - y0)));
}

function Delay(n) { this.buf = new Float64Array(n); this.i = 0; }
Delay.prototype.write = function (x) { this.buf[this.i] = x; this.i = (this.i + 1) % this.buf.length; };
Delay.prototype.read = function (t) { // t samples ago, t=1 = last write
    var n = this.buf.length, pos = this.i - t, i1 = Math.floor(pos), b = this.buf;
    function at(k) { return b[((i1 + k) % n + n) % n]; }
    return cubic(at(-1), at(0), at(1), at(2), pos - i1);
};

function Engine(code) {
    var seed = 1; // seeded noise: every run renders the same pick, so tests never flake
    var st = this.st = {
        samplerate: SR, twopi: 2 * Math.PI, pi: Math.PI, floor: Math.floor, in1: 0, in2: 0, out1: 0, out2: 0,
        mtof: function (m) { return 440 * Math.pow(2, (m - 69) / 12); },
        clamp: function (x, a, b) { return Math.min(b, Math.max(a, x)); },
        wrap: function (x, a, b) { var r = b - a; return x - r * Math.floor((x - a) / r); },
        noise: function () { seed = (seed * 16807) % 2147483647; return seed / 1073741823.5 - 1; },
        dbtoa: function (d) { return Math.pow(10, d / 20); },
        dim: function (buf) { return buf.length; },
        poke: function (buf, v, idx) { if (idx >= 0 && idx < buf.length) buf[Math.floor(idx)] = v; },
        mod: function (x, y) { return x % y; }, fract: function (x) { return x - Math.floor(x); }, round: Math.round, exp2: function (x) { return Math.pow(2, x); },
        peek: function (buf, idx) { // interp="spline", boundmode="ignore": 0 outside the buffer
            if (!(idx >= 0 && idx <= buf.length - 1)) return 0;
            if (idx === Math.floor(idx)) return buf[idx];
            var i1 = Math.floor(idx);
            function at(k) { var j = i1 + k; return j >= 0 && j < buf.length ? buf[j] : 0; }
            return cubic(at(-1), at(0), at(1), at(2), idx - i1);
        },
        min: Math.min, max: Math.max, sin: Math.sin, cos: Math.cos, exp: Math.exp, tanh: Math.tanh,
        atan2: Math.atan2, log: Math.log, sqrt: Math.sqrt, abs: Math.abs, pow: Math.pow
    };
    var body = [];
    code.split("\n").forEach(function (ln) {
        var m = ln.match(/^(Param|History|Delay|Buffer|Data) (\w+)\(([^)]*)\);$/);
        if (!m) return body.push(ln);
        st[m[2]] = m[1] === "Delay" ? new Delay(+m[3]) : m[1] === "Buffer" ? new Float64Array(1) :
            m[1] === "Data" ? new Float64Array(+m[3]) : +m[3];
    });
    // Every local becomes a state slot.
    var js = body.join("\n").replace(/\/\/.*$/gm, "") // comments out: a trailing "." would hide the next line's first name
        .replace(/\b(\w+)="(\w+)"/g, '"$2"'); // interp="cubic" → "cubic"
    // Then every identifier becomes st.name (much faster than `with`), except keywords, "strings" and .members.
    var KW = { "if": 1, "else": 1, "for": 1, "while": 1, "break": 1, "continue": 1 };
    (js.match(/\b[a-zA-Z_]\w*\b/g) || []).forEach(function (id) { if (!(id in st) && !KW[id]) st[id] = 0; });
    js = js.replace(/("[^"]*")|(\.\s*)?\b([a-zA-Z_]\w*)\b/g, function (m, str, dot, id) {
        return str || dot || KW[id] ? m : "st." + id;
    });
    this.tick = new Function("st", js);
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
function rms(x, a, b) { a = Math.round(a); b = Math.round(b); var s = 0; for (var i = a; i < b; i++) s += x[i] * x[i]; return Math.sqrt(s / (b - a)); }

module.exports = { SR: SR, loadCode: loadCode, Engine: Engine, pitchOf: pitchOf, rms: rms };
