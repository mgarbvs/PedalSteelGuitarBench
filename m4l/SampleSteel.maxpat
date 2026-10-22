{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 0,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [
			80.0,
			80.0,
			1700.0,
			900.0
		],
		"openrect": [
			0.0,
			0.0,
			940.0,
			169.0
		],
		"openinpresentation": 1,
		"devicewidth": 940.0,
		"default_fontname": "Ableton Sans Medium",
		"default_fontsize": 10.0,
		"gridsize": [
			8.0,
			8.0
		],
		"editing_bgcolor": [
			0.32,
			0.29,
			0.25,
			1.0
		],
		"description": "Pedal steel playing any sample: drop in a sound, play chords, get steel.",
		"boxes": [
			{
				"box": {
					"id": "thisdev",
					"maxclass": "newobj",
					"text": "live.thisdevice",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"int",
						"int"
					],
					"patching_rect": [
						20,
						20,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "midiin",
					"maxclass": "newobj",
					"text": "midiin",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						60,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "midiparse",
					"maxclass": "newobj",
					"text": "midiparse",
					"numinlets": 1,
					"numoutlets": 8,
					"outlettype": [
						"",
						"",
						"",
						"int",
						"int",
						"int",
						"int",
						""
					],
					"patching_rect": [
						20,
						90,
						63,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_note",
					"maxclass": "newobj",
					"text": "prepend note",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						130,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_cc",
					"maxclass": "newobj",
					"text": "prepend cc",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						130,
						130,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_bend",
					"maxclass": "newobj",
					"text": "prepend bend",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						240,
						130,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "brain",
					"maxclass": "newobj",
					"text": "js steel_brain.js",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						220,
						160,
						22
					]
				}
			},
			{
				"box": {
					"id": "engine",
					"maxclass": "newobj",
					"text": "gen~ @smp ---smp",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"signal"
					],
					"patching_rect": [
						20,
						300,
						160,
						22
					],
					"patcher": {
						"fileversion": 1,
						"appversion": {
							"major": 9,
							"minor": 0,
							"revision": 0,
							"architecture": "x64",
							"modernui": 1
						},
						"classnamespace": "dsp.gen",
						"rect": [
							100.0,
							100.0,
							700.0,
							700.0
						],
						"boxes": [
							{
								"box": {
									"id": "code",
									"maxclass": "codebox",
									"code": "Param vib(0.25);\nParam sustain(30000);\nParam tone(100);\nParam swell(0);\nParam blockall(0);\nParam root(60);\nParam fine(0);\nParam loop(1);\nParam lstart(0.3);\nParam lend(0.9);\nParam smpsr(44100);\nBuffer smp(\"smp\");\nHistory vibph(0);\nHistory vibenv(0);\nHistory tlpl(0);\nHistory tlpr(0);\nParam p0(66);\nParam g0(0);\nParam k0(0);\nParam v0(0.8);\nParam w0(0);\nParam d0(1);\nHistory cur0(66);\nHistory last0(66);\nHistory slope0(0);\nHistory left0(0);\nHistory lastk0(0);\nHistory wait0(-1);\nHistory env0(1);\nHistory pos0(0);\nHistory amp0(0);\nHistory opos0(0);\nHistory oamp0(0);\nHistory ofade0(0);\nParam p1(63);\nParam g1(0);\nParam k1(0);\nParam v1(0.8);\nParam w1(0);\nParam d1(1);\nHistory cur1(63);\nHistory last1(63);\nHistory slope1(0);\nHistory left1(0);\nHistory lastk1(0);\nHistory wait1(-1);\nHistory env1(1);\nHistory pos1(0);\nHistory amp1(0);\nHistory opos1(0);\nHistory oamp1(0);\nHistory ofade1(0);\nParam p2(68);\nParam g2(0);\nParam k2(0);\nParam v2(0.8);\nParam w2(0);\nParam d2(1);\nHistory cur2(68);\nHistory last2(68);\nHistory slope2(0);\nHistory left2(0);\nHistory lastk2(0);\nHistory wait2(-1);\nHistory env2(1);\nHistory pos2(0);\nHistory amp2(0);\nHistory opos2(0);\nHistory oamp2(0);\nHistory ofade2(0);\nParam p3(64);\nParam g3(0);\nParam k3(0);\nParam v3(0.8);\nParam w3(0);\nParam d3(1);\nHistory cur3(64);\nHistory last3(64);\nHistory slope3(0);\nHistory left3(0);\nHistory lastk3(0);\nHistory wait3(-1);\nHistory env3(1);\nHistory pos3(0);\nHistory amp3(0);\nHistory opos3(0);\nHistory oamp3(0);\nHistory ofade3(0);\nParam p4(59);\nParam g4(0);\nParam k4(0);\nParam v4(0.8);\nParam w4(0);\nParam d4(1);\nHistory cur4(59);\nHistory last4(59);\nHistory slope4(0);\nHistory left4(0);\nHistory lastk4(0);\nHistory wait4(-1);\nHistory env4(1);\nHistory pos4(0);\nHistory amp4(0);\nHistory opos4(0);\nHistory oamp4(0);\nHistory ofade4(0);\nParam p5(56);\nParam g5(0);\nParam k5(0);\nParam v5(0.8);\nParam w5(0);\nParam d5(1);\nHistory cur5(56);\nHistory last5(56);\nHistory slope5(0);\nHistory left5(0);\nHistory lastk5(0);\nHistory wait5(-1);\nHistory env5(1);\nHistory pos5(0);\nHistory amp5(0);\nHistory opos5(0);\nHistory oamp5(0);\nHistory ofade5(0);\nParam p6(54);\nParam g6(0);\nParam k6(0);\nParam v6(0.8);\nParam w6(0);\nParam d6(1);\nHistory cur6(54);\nHistory last6(54);\nHistory slope6(0);\nHistory left6(0);\nHistory lastk6(0);\nHistory wait6(-1);\nHistory env6(1);\nHistory pos6(0);\nHistory amp6(0);\nHistory opos6(0);\nHistory oamp6(0);\nHistory ofade6(0);\nParam p7(52);\nParam g7(0);\nParam k7(0);\nParam v7(0.8);\nParam w7(0);\nParam d7(1);\nHistory cur7(52);\nHistory last7(52);\nHistory slope7(0);\nHistory left7(0);\nHistory lastk7(0);\nHistory wait7(-1);\nHistory env7(1);\nHistory pos7(0);\nHistory amp7(0);\nHistory opos7(0);\nHistory oamp7(0);\nHistory ofade7(0);\nParam p8(50);\nParam g8(0);\nParam k8(0);\nParam v8(0.8);\nParam w8(0);\nParam d8(1);\nHistory cur8(50);\nHistory last8(50);\nHistory slope8(0);\nHistory left8(0);\nHistory lastk8(0);\nHistory wait8(-1);\nHistory env8(1);\nHistory pos8(0);\nHistory amp8(0);\nHistory opos8(0);\nHistory oamp8(0);\nHistory ofade8(0);\nParam p9(47);\nParam g9(0);\nParam k9(0);\nParam v9(0.8);\nParam w9(0);\nParam d9(1);\nHistory cur9(47);\nHistory last9(47);\nHistory slope9(0);\nHistory left9(0);\nHistory lastk9(0);\nHistory wait9(-1);\nHistory env9(1);\nHistory pos9(0);\nHistory amp9(0);\nHistory opos9(0);\nHistory oamp9(0);\nHistory ofade9(0);\nParam reverb(30);\nParam volume(0);\nParam volpedal(1);\nHistory volsm(1);\nHistory revsm(0.3);\nHistory dcxl(0);\nHistory dcyl(0);\nHistory dcxr(0);\nHistory dcyr(0);\nDelay rvdl(8192);\nHistory rvlfol(0);\nHistory rvlpl(0);\nHistory rvhpl(0);\nDelay rval0(8192);\nDelay rval1(8192);\nDelay rval2(8192);\nDelay rval3(8192);\nDelay rval4(8192);\nDelay rval5(8192);\nDelay rvdr(8192);\nHistory rvlfor(0);\nHistory rvlpr(0);\nHistory rvhpr(0);\nDelay rvar0(8192);\nDelay rvar1(8192);\nDelay rvar2(8192);\nDelay rvar3(8192);\nDelay rvar4(8192);\nDelay rvar5(8192);\nsr = samplerate;\nn = 0; y = 0; o = 0; inc = 0; s = 0; fade = 0; plucked = 0; L = 0; R = 0;\nvibph = wrap(vibph + 5.5 / sr, 0, 1);\nvibenv = min(1, vibenv + 1 / (0.7 * sr));\nvibamt = sin(vibph * twopi) * vib * 0.3 * vibenv;\nswelling = swell > 1;\nswinc = 1 / max(1, swell * sr / 1000);\nlen = dim(smp);\nratek = smpsr / sr / mtof(root + fine / 100);\nls = min(lstart, lend) * len;\nle = max(lstart, lend) * len;\nll = le - ls;\nlooping = loop > 0.5 && ll > 100;\nxfcap = min(ll * 0.5, 0.05 * smpsr);\nxfpre = min(xfcap, ls);\nxfpost = min(xfcap, len - le);\nxf = max(xfpre, xfpost);\nxfading = looping && xf >= 1;\nlw = xfpost > xfpre ? le + xf : le;\nxfstart = lw - xf;\nofinc = 1 / (0.005 * sr);\nrelk = exp(-6.9078 / (0.15 * sr));\nsusk = sustain >= 29999 ? 1 : exp(-6.9078 / (sustain * sr / 1000));\n\n// voice 0\nif (p0 != last0) { n = max(1, g0 * sr / 1000); slope0 = (p0 - cur0) / n; left0 = n; last0 = p0; }\nif (left0 > 0) { cur0 = cur0 + slope0; left0 = left0 - 1; if (left0 <= 0) { cur0 = last0; } }\nif (k0 != lastk0) { lastk0 = k0; wait0 = w0 * sr / 1000; }\nif (wait0 >= 0) {\n    wait0 = wait0 - 1;\n    if (wait0 < 0) {\n        ofade0 = amp0 > 0.00001; oamp0 = amp0 * env0 * env0; opos0 = pos0;   // the ringing note fades out\n        pos0 = 0; amp0 = v0 * v0; env0 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp0 > 0.00001) {\n    inc = mtof(cur0 + vibamt + 0.015) * ratek;\n    y = peek(smp, pos0, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos0 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos0 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos0 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade0 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos0, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos0 > xfstart) {\n            fade = min(1, (opos0 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos0 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp0 * ofade0;\n        opos0 = opos0 + inc;\n        if (looping && opos0 >= lw) { opos0 = opos0 - ll; }\n        ofade0 = ofade0 - ofinc;\n    }\n    pos0 = pos0 + inc;\n    if (looping && pos0 >= lw) { pos0 = pos0 - ll; }\n    if (pos0 >= len) { amp0 = 0; }   // one-shot: the note ends with the sample\n    amp0 = amp0 * (d0 > 0 ? relk : susk);\n}\nenv0 = swelling ? min(1, env0 + swinc) : 1;\ns = (y * amp0 * env0 * env0 + o) * 0.35;\nL = L + s * 0.309;\nR = R + s * 0.9511;\n\n\n// voice 1\nif (p1 != last1) { n = max(1, g1 * sr / 1000); slope1 = (p1 - cur1) / n; left1 = n; last1 = p1; }\nif (left1 > 0) { cur1 = cur1 + slope1; left1 = left1 - 1; if (left1 <= 0) { cur1 = last1; } }\nif (k1 != lastk1) { lastk1 = k1; wait1 = w1 * sr / 1000; }\nif (wait1 >= 0) {\n    wait1 = wait1 - 1;\n    if (wait1 < 0) {\n        ofade1 = amp1 > 0.00001; oamp1 = amp1 * env1 * env1; opos1 = pos1;   // the ringing note fades out\n        pos1 = 0; amp1 = v1 * v1; env1 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp1 > 0.00001) {\n    inc = mtof(cur1 + vibamt + -0.01) * ratek;\n    y = peek(smp, pos1, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos1 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos1 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos1 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade1 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos1, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos1 > xfstart) {\n            fade = min(1, (opos1 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos1 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp1 * ofade1;\n        opos1 = opos1 + inc;\n        if (looping && opos1 >= lw) { opos1 = opos1 - ll; }\n        ofade1 = ofade1 - ofinc;\n    }\n    pos1 = pos1 + inc;\n    if (looping && pos1 >= lw) { pos1 = pos1 - ll; }\n    if (pos1 >= len) { amp1 = 0; }   // one-shot: the note ends with the sample\n    amp1 = amp1 * (d1 > 0 ? relk : susk);\n}\nenv1 = swelling ? min(1, env1 + swinc) : 1;\ns = (y * amp1 * env1 * env1 + o) * 0.35;\nL = L + s * 0.4067;\nR = R + s * 0.9135;\n\n\n// voice 2\nif (p2 != last2) { n = max(1, g2 * sr / 1000); slope2 = (p2 - cur2) / n; left2 = n; last2 = p2; }\nif (left2 > 0) { cur2 = cur2 + slope2; left2 = left2 - 1; if (left2 <= 0) { cur2 = last2; } }\nif (k2 != lastk2) { lastk2 = k2; wait2 = w2 * sr / 1000; }\nif (wait2 >= 0) {\n    wait2 = wait2 - 1;\n    if (wait2 < 0) {\n        ofade2 = amp2 > 0.00001; oamp2 = amp2 * env2 * env2; opos2 = pos2;   // the ringing note fades out\n        pos2 = 0; amp2 = v2 * v2; env2 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp2 > 0.00001) {\n    inc = mtof(cur2 + vibamt + 0.005) * ratek;\n    y = peek(smp, pos2, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos2 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos2 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos2 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade2 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos2, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos2 > xfstart) {\n            fade = min(1, (opos2 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos2 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp2 * ofade2;\n        opos2 = opos2 + inc;\n        if (looping && opos2 >= lw) { opos2 = opos2 - ll; }\n        ofade2 = ofade2 - ofinc;\n    }\n    pos2 = pos2 + inc;\n    if (looping && pos2 >= lw) { pos2 = pos2 - ll; }\n    if (pos2 >= len) { amp2 = 0; }   // one-shot: the note ends with the sample\n    amp2 = amp2 * (d2 > 0 ? relk : susk);\n}\nenv2 = swelling ? min(1, env2 + swinc) : 1;\ns = (y * amp2 * env2 * env2 + o) * 0.35;\nL = L + s * 0.5;\nR = R + s * 0.866;\n\n\n// voice 3\nif (p3 != last3) { n = max(1, g3 * sr / 1000); slope3 = (p3 - cur3) / n; left3 = n; last3 = p3; }\nif (left3 > 0) { cur3 = cur3 + slope3; left3 = left3 - 1; if (left3 <= 0) { cur3 = last3; } }\nif (k3 != lastk3) { lastk3 = k3; wait3 = w3 * sr / 1000; }\nif (wait3 >= 0) {\n    wait3 = wait3 - 1;\n    if (wait3 < 0) {\n        ofade3 = amp3 > 0.00001; oamp3 = amp3 * env3 * env3; opos3 = pos3;   // the ringing note fades out\n        pos3 = 0; amp3 = v3 * v3; env3 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp3 > 0.00001) {\n    inc = mtof(cur3 + vibamt + -0.015) * ratek;\n    y = peek(smp, pos3, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos3 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos3 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos3 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade3 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos3, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos3 > xfstart) {\n            fade = min(1, (opos3 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos3 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp3 * ofade3;\n        opos3 = opos3 + inc;\n        if (looping && opos3 >= lw) { opos3 = opos3 - ll; }\n        ofade3 = ofade3 - ofinc;\n    }\n    pos3 = pos3 + inc;\n    if (looping && pos3 >= lw) { pos3 = pos3 - ll; }\n    if (pos3 >= len) { amp3 = 0; }   // one-shot: the note ends with the sample\n    amp3 = amp3 * (d3 > 0 ? relk : susk);\n}\nenv3 = swelling ? min(1, env3 + swinc) : 1;\ns = (y * amp3 * env3 * env3 + o) * 0.35;\nL = L + s * 0.5878;\nR = R + s * 0.809;\n\n\n// voice 4\nif (p4 != last4) { n = max(1, g4 * sr / 1000); slope4 = (p4 - cur4) / n; left4 = n; last4 = p4; }\nif (left4 > 0) { cur4 = cur4 + slope4; left4 = left4 - 1; if (left4 <= 0) { cur4 = last4; } }\nif (k4 != lastk4) { lastk4 = k4; wait4 = w4 * sr / 1000; }\nif (wait4 >= 0) {\n    wait4 = wait4 - 1;\n    if (wait4 < 0) {\n        ofade4 = amp4 > 0.00001; oamp4 = amp4 * env4 * env4; opos4 = pos4;   // the ringing note fades out\n        pos4 = 0; amp4 = v4 * v4; env4 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp4 > 0.00001) {\n    inc = mtof(cur4 + vibamt + 0.01) * ratek;\n    y = peek(smp, pos4, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos4 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos4 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos4 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade4 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos4, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos4 > xfstart) {\n            fade = min(1, (opos4 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos4 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp4 * ofade4;\n        opos4 = opos4 + inc;\n        if (looping && opos4 >= lw) { opos4 = opos4 - ll; }\n        ofade4 = ofade4 - ofinc;\n    }\n    pos4 = pos4 + inc;\n    if (looping && pos4 >= lw) { pos4 = pos4 - ll; }\n    if (pos4 >= len) { amp4 = 0; }   // one-shot: the note ends with the sample\n    amp4 = amp4 * (d4 > 0 ? relk : susk);\n}\nenv4 = swelling ? min(1, env4 + swinc) : 1;\ns = (y * amp4 * env4 * env4 + o) * 0.35;\nL = L + s * 0.6691;\nR = R + s * 0.7431;\n\n\n// voice 5\nif (p5 != last5) { n = max(1, g5 * sr / 1000); slope5 = (p5 - cur5) / n; left5 = n; last5 = p5; }\nif (left5 > 0) { cur5 = cur5 + slope5; left5 = left5 - 1; if (left5 <= 0) { cur5 = last5; } }\nif (k5 != lastk5) { lastk5 = k5; wait5 = w5 * sr / 1000; }\nif (wait5 >= 0) {\n    wait5 = wait5 - 1;\n    if (wait5 < 0) {\n        ofade5 = amp5 > 0.00001; oamp5 = amp5 * env5 * env5; opos5 = pos5;   // the ringing note fades out\n        pos5 = 0; amp5 = v5 * v5; env5 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp5 > 0.00001) {\n    inc = mtof(cur5 + vibamt + -0.005) * ratek;\n    y = peek(smp, pos5, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos5 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos5 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos5 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade5 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos5, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos5 > xfstart) {\n            fade = min(1, (opos5 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos5 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp5 * ofade5;\n        opos5 = opos5 + inc;\n        if (looping && opos5 >= lw) { opos5 = opos5 - ll; }\n        ofade5 = ofade5 - ofinc;\n    }\n    pos5 = pos5 + inc;\n    if (looping && pos5 >= lw) { pos5 = pos5 - ll; }\n    if (pos5 >= len) { amp5 = 0; }   // one-shot: the note ends with the sample\n    amp5 = amp5 * (d5 > 0 ? relk : susk);\n}\nenv5 = swelling ? min(1, env5 + swinc) : 1;\ns = (y * amp5 * env5 * env5 + o) * 0.35;\nL = L + s * 0.7431;\nR = R + s * 0.6691;\n\n\n// voice 6\nif (p6 != last6) { n = max(1, g6 * sr / 1000); slope6 = (p6 - cur6) / n; left6 = n; last6 = p6; }\nif (left6 > 0) { cur6 = cur6 + slope6; left6 = left6 - 1; if (left6 <= 0) { cur6 = last6; } }\nif (k6 != lastk6) { lastk6 = k6; wait6 = w6 * sr / 1000; }\nif (wait6 >= 0) {\n    wait6 = wait6 - 1;\n    if (wait6 < 0) {\n        ofade6 = amp6 > 0.00001; oamp6 = amp6 * env6 * env6; opos6 = pos6;   // the ringing note fades out\n        pos6 = 0; amp6 = v6 * v6; env6 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp6 > 0.00001) {\n    inc = mtof(cur6 + vibamt + 0.015) * ratek;\n    y = peek(smp, pos6, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos6 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos6 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos6 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade6 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos6, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos6 > xfstart) {\n            fade = min(1, (opos6 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos6 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp6 * ofade6;\n        opos6 = opos6 + inc;\n        if (looping && opos6 >= lw) { opos6 = opos6 - ll; }\n        ofade6 = ofade6 - ofinc;\n    }\n    pos6 = pos6 + inc;\n    if (looping && pos6 >= lw) { pos6 = pos6 - ll; }\n    if (pos6 >= len) { amp6 = 0; }   // one-shot: the note ends with the sample\n    amp6 = amp6 * (d6 > 0 ? relk : susk);\n}\nenv6 = swelling ? min(1, env6 + swinc) : 1;\ns = (y * amp6 * env6 * env6 + o) * 0.35;\nL = L + s * 0.809;\nR = R + s * 0.5878;\n\n\n// voice 7\nif (p7 != last7) { n = max(1, g7 * sr / 1000); slope7 = (p7 - cur7) / n; left7 = n; last7 = p7; }\nif (left7 > 0) { cur7 = cur7 + slope7; left7 = left7 - 1; if (left7 <= 0) { cur7 = last7; } }\nif (k7 != lastk7) { lastk7 = k7; wait7 = w7 * sr / 1000; }\nif (wait7 >= 0) {\n    wait7 = wait7 - 1;\n    if (wait7 < 0) {\n        ofade7 = amp7 > 0.00001; oamp7 = amp7 * env7 * env7; opos7 = pos7;   // the ringing note fades out\n        pos7 = 0; amp7 = v7 * v7; env7 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp7 > 0.00001) {\n    inc = mtof(cur7 + vibamt + -0.01) * ratek;\n    y = peek(smp, pos7, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos7 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos7 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos7 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade7 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos7, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos7 > xfstart) {\n            fade = min(1, (opos7 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos7 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp7 * ofade7;\n        opos7 = opos7 + inc;\n        if (looping && opos7 >= lw) { opos7 = opos7 - ll; }\n        ofade7 = ofade7 - ofinc;\n    }\n    pos7 = pos7 + inc;\n    if (looping && pos7 >= lw) { pos7 = pos7 - ll; }\n    if (pos7 >= len) { amp7 = 0; }   // one-shot: the note ends with the sample\n    amp7 = amp7 * (d7 > 0 ? relk : susk);\n}\nenv7 = swelling ? min(1, env7 + swinc) : 1;\ns = (y * amp7 * env7 * env7 + o) * 0.35;\nL = L + s * 0.866;\nR = R + s * 0.5;\n\n\n// voice 8\nif (p8 != last8) { n = max(1, g8 * sr / 1000); slope8 = (p8 - cur8) / n; left8 = n; last8 = p8; }\nif (left8 > 0) { cur8 = cur8 + slope8; left8 = left8 - 1; if (left8 <= 0) { cur8 = last8; } }\nif (k8 != lastk8) { lastk8 = k8; wait8 = w8 * sr / 1000; }\nif (wait8 >= 0) {\n    wait8 = wait8 - 1;\n    if (wait8 < 0) {\n        ofade8 = amp8 > 0.00001; oamp8 = amp8 * env8 * env8; opos8 = pos8;   // the ringing note fades out\n        pos8 = 0; amp8 = v8 * v8; env8 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp8 > 0.00001) {\n    inc = mtof(cur8 + vibamt + 0.005) * ratek;\n    y = peek(smp, pos8, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos8 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos8 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos8 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade8 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos8, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos8 > xfstart) {\n            fade = min(1, (opos8 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos8 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp8 * ofade8;\n        opos8 = opos8 + inc;\n        if (looping && opos8 >= lw) { opos8 = opos8 - ll; }\n        ofade8 = ofade8 - ofinc;\n    }\n    pos8 = pos8 + inc;\n    if (looping && pos8 >= lw) { pos8 = pos8 - ll; }\n    if (pos8 >= len) { amp8 = 0; }   // one-shot: the note ends with the sample\n    amp8 = amp8 * (d8 > 0 ? relk : susk);\n}\nenv8 = swelling ? min(1, env8 + swinc) : 1;\ns = (y * amp8 * env8 * env8 + o) * 0.35;\nL = L + s * 0.9135;\nR = R + s * 0.4067;\n\n\n// voice 9\nif (p9 != last9) { n = max(1, g9 * sr / 1000); slope9 = (p9 - cur9) / n; left9 = n; last9 = p9; }\nif (left9 > 0) { cur9 = cur9 + slope9; left9 = left9 - 1; if (left9 <= 0) { cur9 = last9; } }\nif (k9 != lastk9) { lastk9 = k9; wait9 = w9 * sr / 1000; }\nif (wait9 >= 0) {\n    wait9 = wait9 - 1;\n    if (wait9 < 0) {\n        ofade9 = amp9 > 0.00001; oamp9 = amp9 * env9 * env9; opos9 = pos9;   // the ringing note fades out\n        pos9 = 0; amp9 = v9 * v9; env9 = swelling ? 0 : 1; plucked = 1;\n    }\n}\ny = 0; o = 0;\nif (amp9 > 0.00001) {\n    inc = mtof(cur9 + vibamt + -0.015) * ratek;\n    y = peek(smp, pos9, 0, interp=\"spline\", boundmode=\"ignore\");\n    if (xfading && pos9 > xfstart) {   // equal-power crossfade into the loop start: no click at the seam\n        fade = min(1, (pos9 - xfstart) / xf);   // past End (knob moved, shorter sample): >1 \u2192 sqrt NaN \u2192 silence\n        y = y * sqrt(1 - fade) + peek(smp, pos9 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n    }\n    if (ofade9 > 0) {   // re-picked while ringing: the old note keeps playing under the new one for 5 ms\n        o = peek(smp, opos9, 0, interp=\"spline\", boundmode=\"ignore\");\n        if (xfading && opos9 > xfstart) {\n            fade = min(1, (opos9 - xfstart) / xf);\n            o = o * sqrt(1 - fade) + peek(smp, opos9 - ll, 0, interp=\"spline\", boundmode=\"ignore\") * sqrt(fade);\n        }\n        o = o * oamp9 * ofade9;\n        opos9 = opos9 + inc;\n        if (looping && opos9 >= lw) { opos9 = opos9 - ll; }\n        ofade9 = ofade9 - ofinc;\n    }\n    pos9 = pos9 + inc;\n    if (looping && pos9 >= lw) { pos9 = pos9 - ll; }\n    if (pos9 >= len) { amp9 = 0; }   // one-shot: the note ends with the sample\n    amp9 = amp9 * (d9 > 0 ? relk : susk);\n}\nenv9 = swelling ? min(1, env9 + swinc) : 1;\ns = (y * amp9 * env9 * env9 + o) * 0.35;\nL = L + s * 0.9511;\nR = R + s * 0.309;\n\nif (plucked) { vibenv = 0; }\ntonek = 1 - exp(-twopi * 200 * pow(2, tone * 0.066) / sr);\ntlpl = tlpl + tonek * (L - tlpl); L = tlpl;\ntlpr = tlpr + tonek * (R - tlpr); R = tlpr;\ndryl = tanh(L * 0.7);\ndryr = tanh(R * 0.7);\nrin = (dryl + dryr) * 0.04;\nrevsm = revsm + 0.001 * (reverb * 0.01 - revsm);\nrvlfol = wrap(rvlfol + 0.13 / sr, 0, 1);\nrvlenl = (34.0 + 1.2 * sin(rvlfol * twopi)) * sr / 1000;\nrvloopyl = rvdl.read(rvlenl, interp=\"cubic\");\nrvlpl = rvloopyl * 0.45 + rvlpl * 0.55;\nrvhpl = rvhpl + 0.013 * (rvlpl - rvhpl);\nrvbandl = rvlpl - rvhpl;\nrvyl0 = rval0.read(71 * sr / 44100);\nrvvl0 = rvbandl + rvyl0 * 0.6;\nrval0.write(rvvl0);\nrvapl0 = rvyl0 - 0.6 * rvvl0;\nrvyl1 = rval1.read(97 * sr / 44100);\nrvvl1 = rvapl0 + rvyl1 * 0.6;\nrval1.write(rvvl1);\nrvapl1 = rvyl1 - 0.6 * rvvl1;\nrvyl2 = rval2.read(127 * sr / 44100);\nrvvl2 = rvapl1 + rvyl2 * 0.6;\nrval2.write(rvvl2);\nrvapl2 = rvyl2 - 0.6 * rvvl2;\nrvyl3 = rval3.read(157 * sr / 44100);\nrvvl3 = rvapl2 + rvyl3 * 0.6;\nrval3.write(rvvl3);\nrvapl3 = rvyl3 - 0.6 * rvvl3;\nrvyl4 = rval4.read(191 * sr / 44100);\nrvvl4 = rvapl3 + rvyl4 * 0.6;\nrval4.write(rvvl4);\nrvapl4 = rvyl4 - 0.6 * rvvl4;\nrvyl5 = rval5.read(223 * sr / 44100);\nrvvl5 = rvapl4 + rvyl5 * 0.6;\nrval5.write(rvvl5);\nrvapl5 = rvyl5 - 0.6 * rvvl5;\nrvdl.write(clamp(rin + rvapl5 * 0.85, -4, 4));\nwetl = rvapl5;\nrvlfor = wrap(rvlfor + 0.19 / sr, 0, 1);\nrvlenr = (45.0 + 1.2 * sin(rvlfor * twopi)) * sr / 1000;\nrvloopyr = rvdr.read(rvlenr, interp=\"cubic\");\nrvlpr = rvloopyr * 0.45 + rvlpr * 0.55;\nrvhpr = rvhpr + 0.013 * (rvlpr - rvhpr);\nrvbandr = rvlpr - rvhpr;\nrvyr0 = rvar0.read(94 * sr / 44100);\nrvvr0 = rvbandr + rvyr0 * 0.6;\nrvar0.write(rvvr0);\nrvapr0 = rvyr0 - 0.6 * rvvr0;\nrvyr1 = rvar1.read(120 * sr / 44100);\nrvvr1 = rvapr0 + rvyr1 * 0.6;\nrvar1.write(rvvr1);\nrvapr1 = rvyr1 - 0.6 * rvvr1;\nrvyr2 = rvar2.read(150 * sr / 44100);\nrvvr2 = rvapr1 + rvyr2 * 0.6;\nrvar2.write(rvvr2);\nrvapr2 = rvyr2 - 0.6 * rvvr2;\nrvyr3 = rvar3.read(180 * sr / 44100);\nrvvr3 = rvapr2 + rvyr3 * 0.6;\nrvar3.write(rvvr3);\nrvapr3 = rvyr3 - 0.6 * rvvr3;\nrvyr4 = rvar4.read(214 * sr / 44100);\nrvvr4 = rvapr3 + rvyr4 * 0.6;\nrvar4.write(rvvr4);\nrvapr4 = rvyr4 - 0.6 * rvvr4;\nrvyr5 = rvar5.read(246 * sr / 44100);\nrvvr5 = rvapr4 + rvyr5 * 0.6;\nrvar5.write(rvvr5);\nrvapr5 = rvyr5 - 0.6 * rvvr5;\nrvdr.write(clamp(rin + rvapr5 * 0.85, -4, 4));\nwetr = rvapr5;\nvolsm = volsm + 0.001 * (dbtoa(volume) * volpedal - volsm);\noutl = (dryl + wetl * revsm) * volsm;\noutr = (dryr + wetr * revsm) * volsm;\ndcyl = outl - dcxl + 0.995 * dcyl; dcxl = outl;\ndcyr = outr - dcxr + 0.995 * dcyr; dcxr = outr;\nout1 = tanh(dcyl);\nout2 = tanh(dcyr);\n",
									"fontface": 0,
									"fontname": "<Monospaced>",
									"fontsize": 12.0,
									"numinlets": 0,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										20.0,
										20.0,
										640.0,
										560.0
									]
								}
							},
							{
								"box": {
									"id": "out1",
									"maxclass": "newobj",
									"text": "out 1",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										20.0,
										600.0,
										40.0,
										22.0
									]
								}
							},
							{
								"box": {
									"id": "out2",
									"maxclass": "newobj",
									"text": "out 2",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										620.0,
										600.0,
										40.0,
										22.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"source": [
										"code",
										0
									],
									"destination": [
										"out1",
										0
									]
								}
							},
							{
								"patchline": {
									"source": [
										"code",
										1
									],
									"destination": [
										"out2",
										0
									]
								}
							}
						]
					}
				}
			},
			{
				"box": {
					"id": "plugout",
					"maxclass": "newobj",
					"text": "plugout~",
					"numinlets": 2,
					"numoutlets": 0,
					"outlettype": [],
					"patching_rect": [
						20,
						360,
						56,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_A",
					"maxclass": "live.text",
					"varname": "ped_A",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "A Pedal",
					"annotation": "Raises strings 5 and 10 from B to C#. Pressed together with B, it turns the open E chord into A: the classic pedal steel sound. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						938,
						700,
						30,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						42,
						118,
						30,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal A",
							"parameter_shortname": "A",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_A",
					"maxclass": "newobj",
					"text": "prepend pedal A",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						938,
						740,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_B",
					"maxclass": "live.text",
					"varname": "ped_B",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "B Pedal",
					"annotation": "Raises strings 3 and 6 from G# to A. Pressed together with A, it turns the open E chord into A: the classic pedal steel sound. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						972,
						700,
						30,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						76,
						118,
						30,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal B",
							"parameter_shortname": "B",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_B",
					"maxclass": "newobj",
					"text": "prepend pedal B",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						972,
						740,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_C",
					"maxclass": "live.text",
					"varname": "ped_C",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "C Pedal",
					"annotation": "Raises string 4 from E to F# and string 5 from B to C#. Pressed with B, it turns the E chord into F# minor. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						1006,
						700,
						30,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						110,
						118,
						30,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal C",
							"parameter_shortname": "C",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_C",
					"maxclass": "newobj",
					"text": "prepend pedal C",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1006,
						740,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_LKL",
					"maxclass": "live.text",
					"varname": "ped_LKL",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "LKL Knee Lever",
					"annotation": "Left knee lever, pushed left: raises both E strings (4 and 8) a half step to F. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						1050,
						700,
						36,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						154,
						118,
						36,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal LKL",
							"parameter_shortname": "LKL",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_LKL",
					"maxclass": "newobj",
					"text": "prepend pedal LKL",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1050,
						740,
						119,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_LKR",
					"maxclass": "live.text",
					"varname": "ped_LKR",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "LKR Knee Lever",
					"annotation": "Left knee lever, pushed right: lowers both E strings (4 and 8) a half step to D#. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						1090,
						700,
						36,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						194,
						118,
						36,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal LKR",
							"parameter_shortname": "LKR",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_LKR",
					"maxclass": "newobj",
					"text": "prepend pedal LKR",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1090,
						740,
						119,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_RKL",
					"maxclass": "live.text",
					"varname": "ped_RKL",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "RKL Knee Lever",
					"annotation": "Right knee lever, pushed left: raises both F# strings (1 and 7) a half step to G. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						1130,
						700,
						36,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						234,
						118,
						36,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal RKL",
							"parameter_shortname": "RKL",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_RKL",
					"maxclass": "newobj",
					"text": "prepend pedal RKL",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1130,
						740,
						119,
						22
					]
				}
			},
			{
				"box": {
					"id": "ped_RKR",
					"maxclass": "live.text",
					"varname": "ped_RKR",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "",
					"texton": "",
					"annotation_name": "RKR Knee Lever",
					"annotation": "Right knee lever, pushed right: lowers string 2 from D# to D and string 9 from D to C#. Good for bluesy 7th-chord sounds. Click to hold it down, click again to let go. In Chords mode the pedals also press themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).",
					"bgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activebgoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"bordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"focusbordercolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextcolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"activetextoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"textoncolor": [
						0.0,
						0.0,
						0.0,
						0.0
					],
					"patching_rect": [
						1170,
						700,
						36,
						20
					],
					"presentation": 1,
					"presentation_rect": [
						274,
						118,
						36,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Pedal RKR",
							"parameter_shortname": "RKR",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_ped_RKR",
					"maxclass": "newobj",
					"text": "prepend pedal RKR",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1170,
						740,
						119,
						22
					]
				}
			},
			{
				"box": {
					"id": "neck",
					"maxclass": "jsui",
					"filename": "steel_neck.js",
					"varname": "neck",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Pedal Steel",
					"annotation": "The steel: strings light up as they ring, the chrome bar shows where the slide is, and the pedals/levers light when they bend a string. Click a string to pick it, drag across the neck to slide the bar, click a pedal or lever to engage it.",
					"patching_rect": [
						300,
						220,
						470,
						158
					],
					"presentation": 1,
					"presentation_rect": [
						4,
						4,
						470,
						158
					]
				}
			},
			{
				"box": {
					"id": "neck_route",
					"maxclass": "newobj",
					"text": "route bar",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						300,
						400,
						63,
						22
					]
				}
			},
			{
				"box": {
					"id": "play_card",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"bgcolor": [
						0.14,
						0.14,
						0.14,
						1.0
					],
					"rounded": 4,
					"background": 1,
					"patching_rect": [
						1380,
						504,
						256,
						76
					],
					"presentation": 1,
					"presentation_rect": [
						480,
						4,
						256,
						76
					]
				}
			},
			{
				"box": {
					"id": "play_lbl",
					"maxclass": "comment",
					"text": "PLAY",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1386,
						506,
						60,
						18
					],
					"presentation": 1,
					"presentation_rect": [
						486,
						6,
						60,
						18
					],
					"fontname": "Ableton Sans Bold",
					"fontsize": 11
				}
			},
			{
				"box": {
					"id": "mode",
					"maxclass": "live.tab",
					"varname": "mode",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"num_lines_patching": 1,
					"num_lines_presentation": 1,
					"annotation_name": "Mode",
					"annotation": "Chords: play anything on your keyboard and it is voiced like a steel player would, with automatic bar slides and pedal bends. Strings: play the real instrument \u2014 white keys C3\u2013E4 pick strings, C2\u2013B2 hold pedals and levers.",
					"patching_rect": [
						1380,
						504,
						150,
						18
					],
					"presentation": 1,
					"presentation_rect": [
						580,
						7,
						150,
						17
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Mode",
							"parameter_shortname": "Mode",
							"parameter_type": 2,
							"parameter_enum": [
								"Chords",
								"Strings"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_mode",
					"maxclass": "newobj",
					"text": "prepend mode",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						480,
						20,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "bar",
					"maxclass": "live.dial",
					"varname": "bar",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bar",
					"annotation": "Where the steel bar sits, in frets. Turn it while strings ring to slide. In Chords mode the bar also moves by itself to fit each chord.",
					"patching_rect": [
						1384,
						528,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						484,
						28,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bar",
							"parameter_shortname": "Bar",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 22.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_unitstyle": 1
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_bar",
					"maxclass": "newobj",
					"text": "prepend bar",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						600,
						60,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "slide",
					"maxclass": "live.dial",
					"varname": "slide",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Slide",
					"annotation": "How long bar slides and pedal bends take when you change chords legato.",
					"patching_rect": [
						1434,
						528,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						534,
						28,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Slide",
							"parameter_shortname": "Slide",
							"parameter_type": 0,
							"parameter_mmin": 20.0,
							"parameter_mmax": 1000.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								180.0
							],
							"parameter_unitstyle": 2,
							"parameter_exponent": 2.0
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_slide",
					"maxclass": "newobj",
					"text": "prepend slide",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						710,
						60,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "strum",
					"maxclass": "live.dial",
					"varname": "strum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Strum",
					"annotation": "Time between strings when a chord is picked. 0 = all at once.",
					"patching_rect": [
						1484,
						528,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						584,
						28,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Strum",
							"parameter_shortname": "Strum",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 80.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								12.0
							],
							"parameter_unitstyle": 2
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_strum",
					"maxclass": "newobj",
					"text": "prepend strum",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						820,
						60,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "bendin",
					"maxclass": "live.dial",
					"varname": "bendin",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bend In",
					"annotation": "How often chords are picked unpedaled and then bent up into place \u2014 the classic pedal steel cry. Higher also makes the player reach for pedals more.",
					"patching_rect": [
						1534,
						528,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						634,
						28,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bend In",
							"parameter_shortname": "BendIn",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								40.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_bendin",
					"maxclass": "newobj",
					"text": "prepend bendin",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						930,
						60,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "vibrato",
					"maxclass": "live.dial",
					"varname": "vibrato",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Vibrato",
					"annotation": "Bar vibrato that fades in on held notes. The mod wheel adds more.",
					"patching_rect": [
						1584,
						528,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						684,
						28,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Vibrato",
							"parameter_shortname": "Vib",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								25.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_vibrato",
					"maxclass": "newobj",
					"text": "prepend vibrato",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1040,
						60,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "sound_card",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"bgcolor": [
						0.14,
						0.14,
						0.14,
						1.0
					],
					"rounded": 4,
					"background": 1,
					"patching_rect": [
						1380,
						584,
						256,
						78
					],
					"presentation": 1,
					"presentation_rect": [
						480,
						84,
						256,
						78
					]
				}
			},
			{
				"box": {
					"id": "sound_lbl",
					"maxclass": "comment",
					"text": "SOUND",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1386,
						586,
						60,
						18
					],
					"presentation": 1,
					"presentation_rect": [
						486,
						86,
						60,
						18
					],
					"fontname": "Ableton Sans Bold",
					"fontsize": 11
				}
			},
			{
				"box": {
					"id": "swell",
					"maxclass": "live.dial",
					"varname": "swell",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Swell",
					"annotation": "Volume-pedal swell on every note: 0 = the sample's own attack, higher = notes fade in.",
					"patching_rect": [
						1384,
						608,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						484,
						108,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Swell",
							"parameter_shortname": "Swell",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 2000.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_unitstyle": 2,
							"parameter_exponent": 2.0
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_swell",
					"maxclass": "newobj",
					"text": "prepend swell",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						600,
						100,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sustain",
					"maxclass": "live.dial",
					"varname": "sustain",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Sustain",
					"annotation": "How long a held note takes to fade. Fully up, held notes never fade (with Loop on).",
					"patching_rect": [
						1434,
						608,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						534,
						108,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Sustain",
							"parameter_shortname": "Sustain",
							"parameter_type": 0,
							"parameter_mmin": 2000.0,
							"parameter_mmax": 30000.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								30000.0
							],
							"parameter_unitstyle": 2
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_sustain",
					"maxclass": "newobj",
					"text": "prepend sustain",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						710,
						100,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "tone",
					"maxclass": "live.dial",
					"varname": "tone",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Tone",
					"annotation": "Low-pass filter: dark and muffled to fully open.",
					"patching_rect": [
						1484,
						608,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						584,
						108,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_tone",
					"maxclass": "newobj",
					"text": "prepend tone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						820,
						100,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "reverb",
					"maxclass": "live.dial",
					"varname": "reverb",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Reverb",
					"annotation": "Amp-style room reverb.",
					"patching_rect": [
						1534,
						608,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						634,
						108,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Reverb",
							"parameter_shortname": "Reverb",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								30.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_reverb",
					"maxclass": "newobj",
					"text": "prepend reverb",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						930,
						100,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "volume",
					"maxclass": "live.dial",
					"varname": "volume",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Volume",
					"annotation": "Output level. An expression pedal (CC 11) works as the steel's volume pedal.",
					"patching_rect": [
						1584,
						608,
						46,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						684,
						108,
						46,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Volume",
							"parameter_shortname": "Vol",
							"parameter_type": 0,
							"parameter_mmin": -40.0,
							"parameter_mmax": 6.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_unitstyle": 4
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_volume",
					"maxclass": "newobj",
					"text": "prepend volume",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1040,
						100,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_ring",
					"maxclass": "newobj",
					"text": "prepend ring",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						600,
						140,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sample_card",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"bgcolor": [
						0.14,
						0.14,
						0.14,
						1.0
					],
					"rounded": 4,
					"background": 1,
					"patching_rect": [
						1640,
						504,
						196,
						158
					],
					"presentation": 1,
					"presentation_rect": [
						740,
						4,
						196,
						158
					]
				}
			},
			{
				"box": {
					"id": "sample_lbl",
					"maxclass": "comment",
					"text": "SAMPLE",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1646,
						506,
						60,
						18
					],
					"presentation": 1,
					"presentation_rect": [
						746,
						6,
						60,
						18
					],
					"fontname": "Ableton Sans Bold",
					"fontsize": 11
				}
			},
			{
				"box": {
					"id": "drop",
					"maxclass": "live.drop",
					"varname": "drop",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"legend": "Drop a sample",
					"annotation_name": "Sample",
					"annotation": "Drop an audio file here (from Live's browser or Finder). Every string plays it, pitched by the Root knob, so pedals bend it and the bar slides it. Single held notes work best: a bowed violin, a sung vowel, an organ.",
					"patching_rect": [
						1640,
						520,
						184,
						56
					],
					"presentation": 1,
					"presentation_rect": [
						746,
						26,
						184,
						20
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Sample",
							"parameter_shortname": "Sample",
							"parameter_type": 4,
							"parameter_invisible": 1,
							"parameter_modmode": 0
						}
					}
				}
			},
			{
				"box": {
					"id": "skip_none",
					"maxclass": "newobj",
					"text": "route none",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1640,
						580,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_replace",
					"maxclass": "newobj",
					"text": "prepend replace",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1640,
						600,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "smpbuf",
					"maxclass": "newobj",
					"text": "buffer~ ---smp",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"float",
						"bang"
					],
					"patching_rect": [
						1640,
						630,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "smpinfo",
					"maxclass": "newobj",
					"text": "info~ ---smp",
					"numinlets": 2,
					"numoutlets": 10,
					"outlettype": [
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1640,
						660,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_smpsr",
					"maxclass": "newobj",
					"text": "prepend smpsr",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1640,
						690,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "loop",
					"maxclass": "live.text",
					"varname": "loop",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "Loop",
					"texton": "Loop",
					"annotation_name": "Loop",
					"annotation": "On: held notes loop the section between Start and End, so they sustain and bend for as long as you hold them (bowed and sustained sounds). Off: the sample plays once and ends (plucked and struck sounds).",
					"patching_rect": [
						1760,
						506,
						50,
						16
					],
					"presentation": 1,
					"presentation_rect": [
						880,
						8,
						50,
						15
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Loop",
							"parameter_shortname": "Loop",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
							]
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_loop",
					"maxclass": "newobj",
					"text": "prepend loop",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1760,
						540,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "root",
					"maxclass": "live.dial",
					"varname": "root",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Root",
					"annotation": "The note the sample was recorded at. Set it to the sample's pitch so every string plays in tune.",
					"patching_rect": [
						1646,
						608,
						44,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						746,
						108,
						44,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Root",
							"parameter_shortname": "Root",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 127.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								60.0
							],
							"parameter_unitstyle": 8
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_root",
					"maxclass": "newobj",
					"text": "prepend root",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1760,
						580,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "fine",
					"maxclass": "live.dial",
					"varname": "fine",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Fine",
					"annotation": "Fine tuning of the sample in cents, for recordings that sit between notes.",
					"patching_rect": [
						1693,
						608,
						44,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						793,
						108,
						44,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Fine",
							"parameter_shortname": "Fine",
							"parameter_type": 0,
							"parameter_mmin": -50.0,
							"parameter_mmax": 50.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_unitstyle": 0
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_fine",
					"maxclass": "newobj",
					"text": "prepend fine",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1870,
						580,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "lstart",
					"maxclass": "live.dial",
					"varname": "lstart",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Loop Start",
					"annotation": "Where the loop begins, as a % of the sample. Put it after the attack.",
					"patching_rect": [
						1740,
						608,
						44,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						840,
						108,
						44,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Loop Start",
							"parameter_shortname": "Start",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								30.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_lstart",
					"maxclass": "newobj",
					"text": "prepend lstart",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1980,
						580,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "scale_lstart",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1980,
						560,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "lend",
					"maxclass": "live.dial",
					"varname": "lend",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Loop End",
					"annotation": "Where the loop ends, as a % of the sample. Put it before the note dies away.",
					"patching_rect": [
						1787,
						608,
						44,
						48
					],
					"presentation": 1,
					"presentation_rect": [
						887,
						108,
						44,
						48
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Loop End",
							"parameter_shortname": "End",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								90.0
							],
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "pre_lend",
					"maxclass": "newobj",
					"text": "prepend lend",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2090,
						580,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "scale_lend",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2090,
						560,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "wave",
					"maxclass": "waveform~",
					"numinlets": 5,
					"numoutlets": 6,
					"outlettype": [
						"float",
						"float",
						"float",
						"float",
						"list",
						"list"
					],
					"buffername": "---smp",
					"labels": 0,
					"ticks": 0,
					"vticks": 0,
					"vlabels": 0,
					"ignoreclick": 1,
					"gridcolor": [
						0,
						0,
						0,
						0
					],
					"labeltextcolor": [
						0,
						0,
						0,
						0
					],
					"labelbgcolor": [
						0,
						0,
						0,
						0
					],
					"bgcolor": [
						0.1,
						0.1,
						0.1,
						1
					],
					"waveformcolor": [
						0.96,
						0.68,
						0.34,
						1
					],
					"selectioncolor": [
						0.96,
						0.68,
						0.34,
						0.25
					],
					"annotation_name": "Waveform",
					"annotation": "The dropped sample. The lit section is the loop (Start to End).",
					"patching_rect": [
						1640,
						740,
						184,
						56
					],
					"presentation": 1,
					"presentation_rect": [
						746,
						48,
						184,
						56
					]
				}
			},
			{
				"box": {
					"id": "len_t",
					"maxclass": "newobj",
					"text": "t b b f",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						"float"
					],
					"patching_rect": [
						1640,
						720,
						49,
						22
					]
				}
			},
			{
				"box": {
					"id": "frac_lstart",
					"maxclass": "newobj",
					"text": "f",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1760,
						800,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "ms_lstart",
					"maxclass": "newobj",
					"text": "* 1.",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1760,
						830,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "frac_lend",
					"maxclass": "newobj",
					"text": "f",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1760,
						830,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "ms_lend",
					"maxclass": "newobj",
					"text": "* 1.",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1760,
						860,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "load_trig",
					"maxclass": "newobj",
					"text": "t b b",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						"bang"
					],
					"patching_rect": [
						20,
						180,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "msg_init",
					"maxclass": "message",
					"text": "init",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						200,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "msg_bang",
					"maxclass": "message",
					"text": "bang",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						80,
						200,
						40,
						22
					]
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"midiin",
						0
					],
					"destination": [
						"midiparse",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midiparse",
						0
					],
					"destination": [
						"pre_note",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midiparse",
						2
					],
					"destination": [
						"pre_cc",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midiparse",
						5
					],
					"destination": [
						"pre_bend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_note",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cc",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bend",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"brain",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"engine",
						0
					],
					"destination": [
						"plugout",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"engine",
						1
					],
					"destination": [
						"plugout",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_A",
						0
					],
					"destination": [
						"pre_ped_A",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_A",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_B",
						0
					],
					"destination": [
						"pre_ped_B",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_B",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_C",
						0
					],
					"destination": [
						"pre_ped_C",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_C",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_LKL",
						0
					],
					"destination": [
						"pre_ped_LKL",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_LKL",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_LKR",
						0
					],
					"destination": [
						"pre_ped_LKR",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_LKR",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_RKL",
						0
					],
					"destination": [
						"pre_ped_RKL",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_RKL",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ped_RKR",
						0
					],
					"destination": [
						"pre_ped_RKR",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ped_RKR",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"brain",
						1
					],
					"destination": [
						"neck",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"neck",
						0
					],
					"destination": [
						"neck_route",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"neck_route",
						1
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mode",
						0
					],
					"destination": [
						"pre_mode",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mode",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bar",
						0
					],
					"destination": [
						"pre_bar",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bar",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"slide",
						0
					],
					"destination": [
						"pre_slide",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_slide",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"strum",
						0
					],
					"destination": [
						"pre_strum",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_strum",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bendin",
						0
					],
					"destination": [
						"pre_bendin",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bendin",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"vibrato",
						0
					],
					"destination": [
						"pre_vibrato",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_vibrato",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"neck_route",
						0
					],
					"destination": [
						"bar",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"swell",
						0
					],
					"destination": [
						"pre_swell",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_swell",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sustain",
						0
					],
					"destination": [
						"pre_sustain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sustain",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tone",
						0
					],
					"destination": [
						"pre_tone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tone",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"reverb",
						0
					],
					"destination": [
						"pre_reverb",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_reverb",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"volume",
						0
					],
					"destination": [
						"pre_volume",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_volume",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sustain",
						0
					],
					"destination": [
						"pre_ring",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ring",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"drop",
						0
					],
					"destination": [
						"skip_none",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"skip_none",
						1
					],
					"destination": [
						"pre_replace",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_replace",
						0
					],
					"destination": [
						"smpbuf",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"smpbuf",
						1
					],
					"destination": [
						"smpinfo",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"smpinfo",
						0
					],
					"destination": [
						"pre_smpsr",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_smpsr",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"loop",
						0
					],
					"destination": [
						"pre_loop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_loop",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"root",
						0
					],
					"destination": [
						"pre_root",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_root",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"fine",
						0
					],
					"destination": [
						"pre_fine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_fine",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lstart",
						0
					],
					"destination": [
						"scale_lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"scale_lstart",
						0
					],
					"destination": [
						"pre_lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lstart",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lend",
						0
					],
					"destination": [
						"scale_lend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"scale_lend",
						0
					],
					"destination": [
						"pre_lend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lend",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"smpinfo",
						6
					],
					"destination": [
						"len_t",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"scale_lstart",
						0
					],
					"destination": [
						"frac_lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"frac_lstart",
						0
					],
					"destination": [
						"ms_lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"len_t",
						2
					],
					"destination": [
						"ms_lstart",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ms_lstart",
						0
					],
					"destination": [
						"wave",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"scale_lend",
						0
					],
					"destination": [
						"frac_lend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"frac_lend",
						0
					],
					"destination": [
						"ms_lend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"len_t",
						2
					],
					"destination": [
						"ms_lend",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ms_lend",
						0
					],
					"destination": [
						"wave",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"len_t",
						0
					],
					"destination": [
						"frac_lend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"len_t",
						1
					],
					"destination": [
						"frac_lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"thisdev",
						0
					],
					"destination": [
						"load_trig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load_trig",
						0
					],
					"destination": [
						"msg_init",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load_trig",
						1
					],
					"destination": [
						"msg_bang",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_init",
						0
					],
					"destination": [
						"brain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"mode",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_A",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_B",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_C",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_LKL",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_LKR",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_RKL",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"ped_RKR",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"bar",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"slide",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"strum",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"bendin",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"vibrato",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"swell",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"sustain",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"tone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"reverb",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"volume",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"drop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"loop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"root",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"fine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"lstart",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bang",
						0
					],
					"destination": [
						"lend",
						0
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"project": {
			"version": 1,
			"creationdate": 3871731238,
			"modificationdate": 3871731238,
			"viewrect": [
				0.0,
				0.0,
				300.0,
				500.0
			],
			"autoorganize": 1,
			"hideprojectwindow": 1,
			"showdependencies": 1,
			"autolocalize": 0,
			"contents": {
				"patchers": {}
			},
			"layout": {},
			"searchpath": {},
			"detailsvisible": 0,
			"amxdtype": 1768515945,
			"readonly": 0,
			"devpathtype": 0,
			"devpath": ".",
			"sortmode": 0,
			"viewmode": 0,
			"includepackages": 0
		}
	}
}