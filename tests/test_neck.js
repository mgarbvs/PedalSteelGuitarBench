// Smoke test for m4l/steel_neck.js. Run with: node tests/test_neck.js
// Stubs the Max jsui globals, requires the script, and pokes at it.

var assert = require("assert");
var path = require("path");

function noop() {}

function makeMgraphics() {
	var known = {
		init: noop,
		relative_coords: 0,
		autofill: 0,
		redraw: noop,
		set_source_rgba: noop,
		rectangle: noop,
		rectangle_rounded: noop,
		move_to: noop,
		line_to: noop,
		stroke: noop,
		fill: noop,
		arc: noop,
		ellipse: noop,
		select_font_face: noop,
		set_font_size: noop,
		text_measure: function (s) { return [String(s).length * 5, 10]; },
		show_text: noop,
		set_line_width: noop,
		set_source: noop,
		fill_preserve: noop,
		stroke_preserve: noop,
		pattern_create_linear: function () {
			return { add_color_stop_rgba: noop };
		}
	};
	if (typeof Proxy === "undefined") return known;
	return new Proxy(known, {
		get: function (target, prop) {
			if (prop in target) return target[prop];
			return noop;
		}
	});
}

function TaskStub(fn, ctx) {
	this.fn = fn;
	this.ctx = ctx;
	this.interval = 0;
	this.running = false;
}
TaskStub.prototype.schedule = noop;
TaskStub.prototype.repeat = function () { this.running = true; };
TaskStub.prototype.cancel = function () { this.running = false; };

global.mgraphics = makeMgraphics();
global.box = { rect: [0, 0, 470, 158] };
global.Task = TaskStub;
global.post = noop;
global.inlets = 1;
global.outlets = 1;

var outletCalls = [];
global.outlet = function () {
	outletCalls.push(Array.prototype.slice.call(arguments));
};

var neck = require(path.join(__dirname, "..", "m4l", "steel_neck.js"));

function lastCall(selector) {
	for (var i = outletCalls.length - 1; i >= 0; i--) {
		if (outletCalls[i][1] === selector) return outletCalls[i];
	}
	return null;
}

// 1. paint() before and after messages, must not throw.
neck.paint();
neck.pitches(66, 63, 68, 64, 59, 56, 54, 52, 50, 47);
neck.bar(3.5);
neck.pedals(1, 0, 2, 3, 0, 0, 1);
neck.pluck(3, 0.8);
neck.release(5);
neck.mode(1);
neck.paint();
console.log("ok: paint() works before and after messages");

// 2. Click at string 3's y inside the neck -> pluck 3 0.8
var g = neck.neckGeom();
outletCalls.length = 0;
neck.onclick(g.x0 + 10, neck.stringY(3, g), 1);
var pluckCall = lastCall("pluck");
assert.ok(pluckCall, "expected a pluck outlet call");
assert.strictEqual(pluckCall[2], 3);
assert.strictEqual(pluckCall[3], 0.8);
console.log("ok: clicking string 3 outputs pluck 3 0.8");

// 4. Drag in the neck area -> bar <0..22>
outletCalls.length = 0;
var startX = g.x0 + 20;
var startY = g.yTop + 5;
neck.onclick(startX, startY, 1);
neck.ondrag(startX + 20, startY, 1);
var barCall = lastCall("bar");
assert.ok(barCall, "expected a bar outlet call while dragging");
assert.ok(barCall[2] >= 0 && barCall[2] <= 22, "bar value should be clamped to 0..22");
console.log("ok: dragging in the neck outputs bar within 0..22 (" + barCall[2] + ")");

console.log("all tests passed");
