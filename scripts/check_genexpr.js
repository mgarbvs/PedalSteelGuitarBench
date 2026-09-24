// node scripts/check_genexpr.js PedalSteel.maxpat — parse every gen~ codebox with
// Cycling '74's own GenExpr grammar (shipped in the RNBO package) and flag calls
// to operators Gen doesn't have. Exit 1 on any problem.
var fs = require("fs");
var RNBO = "/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Max/Max.app/Contents/Resources/C74/packages/RNBO/server/node_modules/@rnbo/genexpr_js/";
var genbo = require(RNBO + "genbo.js");
var ops = {};
JSON.parse(fs.readFileSync(RNBO + "operators.json", "utf8")).forEach(function (o) {
    ops[o.op] = true;
    [].concat(Array.isArray(o.aliases) ? o.aliases : Object.keys(o.aliases || {})).forEach(function (a) { ops[a] = true; });
});

var bad = 0;
(function walk(p) {
    p.boxes.forEach(function (b) {
        b = b.box;
        if (b.maxclass === "codebox") {
            try { genbo.parse(b.code); } catch (e) { bad++; console.error("GenExpr syntax: " + (e.message || e)); return; }
            var params = (b.code.match(/^\s*Param\s+(\w+)/gm) || []).map(function (d) { return d.replace(/^\s*Param\s+/, ""); });
            var assigned = b.code.replace(/\/\/.*$/gm, "").match(/(?:^|[;{}])\s*([a-z_]\w*)\s*=(?!=)/gim) || [];
            params.forEach(function (name) { // a Param named like an operator (e.g. expr) → ": bad number" at DSP start
                if (ops[name]) { bad++; console.error("GenExpr Param shadows an operator: " + name); }
            });
            assigned.forEach(function (a) {
                var name = a.replace(/^[;{}\s]*/, "").replace(/\s*=$/, "");
                if (params.indexOf(name) >= 0) { bad++; console.error("GenExpr can't assign to Param: " + name); }
            });
            var calls = b.code.replace(/\/\/.*$/gm, "").replace(/^\s*(Param|History|Delay|Data|Buffer)\b.*$/gm, "").match(/(^|[^.\w])([a-z_]\w*)\s*\(/gi) || [];
            calls.forEach(function (c) {
                var name = c.replace(/^[^\w]*/, "").replace(/\s*\($/, "");
                if (!ops[name] && ["if"].indexOf(name) < 0) {
                    bad++; console.error("GenExpr unknown operator: " + name);
                }
            });
        }
        if (b.patcher) walk(b.patcher);
    });
})(JSON.parse(fs.readFileSync(process.argv[2], "utf8")).patcher);
if (bad) process.exit(1);
console.log("GenExpr OK: " + process.argv[2]);
