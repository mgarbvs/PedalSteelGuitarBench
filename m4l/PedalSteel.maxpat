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
			740.0,
			169.0
		],
		"openinpresentation": 1,
		"devicewidth": 740.0,
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
		"description": "Pedal steel guitar: play chords, get steel.",
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
					"text": "gen~",
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
									"code": "Param vib(0.25);\nParam sustain(12000);\nParam tone(60);\nParam swell(0);\nParam reverb(30);\nParam volume(0);\nParam volpedal(1);\nHistory vibph(0);\nHistory vibenv(0);\nHistory volsm(1);\nHistory revsm(0.3);\nHistory dcxl(0);\nHistory dcyl(0);\nHistory dcxr(0);\nHistory dcyr(0);\nParam p0(66);\nParam g0(0);\nParam k0(0);\nParam v0(0.8);\nParam w0(0);\nParam d0(1);\nDelay dl0(8192);\nHistory cur0(66);\nHistory last0(66);\nHistory slope0(0);\nHistory left0(0);\nHistory lastk0(0);\nHistory wait0(-1);\nHistory burst0(0);\nHistory vel0(0);\nHistory env0(1);\nHistory lp0(0);\nHistory exlp0(0);\nParam p1(63);\nParam g1(0);\nParam k1(0);\nParam v1(0.8);\nParam w1(0);\nParam d1(1);\nDelay dl1(8192);\nHistory cur1(63);\nHistory last1(63);\nHistory slope1(0);\nHistory left1(0);\nHistory lastk1(0);\nHistory wait1(-1);\nHistory burst1(0);\nHistory vel1(0);\nHistory env1(1);\nHistory lp1(0);\nHistory exlp1(0);\nParam p2(68);\nParam g2(0);\nParam k2(0);\nParam v2(0.8);\nParam w2(0);\nParam d2(1);\nDelay dl2(8192);\nHistory cur2(68);\nHistory last2(68);\nHistory slope2(0);\nHistory left2(0);\nHistory lastk2(0);\nHistory wait2(-1);\nHistory burst2(0);\nHistory vel2(0);\nHistory env2(1);\nHistory lp2(0);\nHistory exlp2(0);\nParam p3(64);\nParam g3(0);\nParam k3(0);\nParam v3(0.8);\nParam w3(0);\nParam d3(1);\nDelay dl3(8192);\nHistory cur3(64);\nHistory last3(64);\nHistory slope3(0);\nHistory left3(0);\nHistory lastk3(0);\nHistory wait3(-1);\nHistory burst3(0);\nHistory vel3(0);\nHistory env3(1);\nHistory lp3(0);\nHistory exlp3(0);\nParam p4(59);\nParam g4(0);\nParam k4(0);\nParam v4(0.8);\nParam w4(0);\nParam d4(1);\nDelay dl4(8192);\nHistory cur4(59);\nHistory last4(59);\nHistory slope4(0);\nHistory left4(0);\nHistory lastk4(0);\nHistory wait4(-1);\nHistory burst4(0);\nHistory vel4(0);\nHistory env4(1);\nHistory lp4(0);\nHistory exlp4(0);\nParam p5(56);\nParam g5(0);\nParam k5(0);\nParam v5(0.8);\nParam w5(0);\nParam d5(1);\nDelay dl5(8192);\nHistory cur5(56);\nHistory last5(56);\nHistory slope5(0);\nHistory left5(0);\nHistory lastk5(0);\nHistory wait5(-1);\nHistory burst5(0);\nHistory vel5(0);\nHistory env5(1);\nHistory lp5(0);\nHistory exlp5(0);\nParam p6(54);\nParam g6(0);\nParam k6(0);\nParam v6(0.8);\nParam w6(0);\nParam d6(1);\nDelay dl6(8192);\nHistory cur6(54);\nHistory last6(54);\nHistory slope6(0);\nHistory left6(0);\nHistory lastk6(0);\nHistory wait6(-1);\nHistory burst6(0);\nHistory vel6(0);\nHistory env6(1);\nHistory lp6(0);\nHistory exlp6(0);\nParam p7(52);\nParam g7(0);\nParam k7(0);\nParam v7(0.8);\nParam w7(0);\nParam d7(1);\nDelay dl7(8192);\nHistory cur7(52);\nHistory last7(52);\nHistory slope7(0);\nHistory left7(0);\nHistory lastk7(0);\nHistory wait7(-1);\nHistory burst7(0);\nHistory vel7(0);\nHistory env7(1);\nHistory lp7(0);\nHistory exlp7(0);\nParam p8(50);\nParam g8(0);\nParam k8(0);\nParam v8(0.8);\nParam w8(0);\nParam d8(1);\nDelay dl8(8192);\nHistory cur8(50);\nHistory last8(50);\nHistory slope8(0);\nHistory left8(0);\nHistory lastk8(0);\nHistory wait8(-1);\nHistory burst8(0);\nHistory vel8(0);\nHistory env8(1);\nHistory lp8(0);\nHistory exlp8(0);\nParam p9(47);\nParam g9(0);\nParam k9(0);\nParam v9(0.8);\nParam w9(0);\nParam d9(1);\nDelay dl9(8192);\nHistory cur9(47);\nHistory last9(47);\nHistory slope9(0);\nHistory left9(0);\nHistory lastk9(0);\nHistory wait9(-1);\nHistory burst9(0);\nHistory vel9(0);\nHistory env9(1);\nHistory lp9(0);\nHistory exlp9(0);\nDelay cl0(8192);\nHistory cfl0(0);\nDelay cl1(8192);\nHistory cfl1(0);\nDelay cl2(8192);\nHistory cfl2(0);\nDelay cl3(8192);\nHistory cfl3(0);\nDelay al0(8192);\nDelay al1(8192);\nDelay cr0(8192);\nHistory cfr0(0);\nDelay cr1(8192);\nHistory cfr1(0);\nDelay cr2(8192);\nHistory cfr2(0);\nDelay cr3(8192);\nHistory cfr3(0);\nDelay ar0(8192);\nDelay ar1(8192);\nsr = samplerate;\nn = 0; f = 0; per = 0; omega = 0; bb = 0; look = 0; x = 0; y = 0; s = 0; plucked = 0; L = 0; R = 0;\nvibph = wrap(vibph + 5.5 / sr, 0, 1);\nvibenv = min(1, vibenv + 1 / (0.7 * sr));\nvibamt = sin(vibph * twopi) * vib * 0.3 * vibenv;\nb = 1 - (0.3 + 0.0065 * tone);\nbd = 1 - (0.3 + 0.0065 * tone) * 0.6;\npickc = 0.15 + 0.008 * tone;\nswelling = swell > 1;\nswinc = 1 / max(1, swell * sr / 1000);\n\n// string 0\nif (p0 != last0) { n = max(1, g0 * sr / 1000); slope0 = (p0 - cur0) / n; left0 = n; last0 = p0; }\nif (left0 > 0) { cur0 = cur0 + slope0; left0 = left0 - 1; if (left0 <= 0) { cur0 = last0; } }\nf = mtof(cur0 + vibamt + 0.015);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d0 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k0 != lastk0) { lastk0 = k0; wait0 = w0 * sr / 1000; }\nif (wait0 >= 0) {\n    wait0 = wait0 - 1;\n    if (wait0 < 0) { burst0 = per; vel0 = v0; env0 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst0 > 0) { exlp0 = exlp0 + pickc * vel0 * (noise() * vel0 - exlp0); x = exlp0; burst0 = burst0 - 1; }\ny = dl0.read(look, interp=\"cubic\");\nlp0 = (1 - bb) * y + bb * lp0;\ndl0.write(clamp(lp0 * exp(-6.9078 * per / ((d0 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv0 = swelling ? min(1, env0 + swinc) : 1;\ns = y * env0 * env0;\nL = L + s * 0.309;\nR = R + s * 0.9511;\n\n\n// string 1\nif (p1 != last1) { n = max(1, g1 * sr / 1000); slope1 = (p1 - cur1) / n; left1 = n; last1 = p1; }\nif (left1 > 0) { cur1 = cur1 + slope1; left1 = left1 - 1; if (left1 <= 0) { cur1 = last1; } }\nf = mtof(cur1 + vibamt + -0.01);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d1 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k1 != lastk1) { lastk1 = k1; wait1 = w1 * sr / 1000; }\nif (wait1 >= 0) {\n    wait1 = wait1 - 1;\n    if (wait1 < 0) { burst1 = per; vel1 = v1; env1 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst1 > 0) { exlp1 = exlp1 + pickc * vel1 * (noise() * vel1 - exlp1); x = exlp1; burst1 = burst1 - 1; }\ny = dl1.read(look, interp=\"cubic\");\nlp1 = (1 - bb) * y + bb * lp1;\ndl1.write(clamp(lp1 * exp(-6.9078 * per / ((d1 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv1 = swelling ? min(1, env1 + swinc) : 1;\ns = y * env1 * env1;\nL = L + s * 0.4067;\nR = R + s * 0.9135;\n\n\n// string 2\nif (p2 != last2) { n = max(1, g2 * sr / 1000); slope2 = (p2 - cur2) / n; left2 = n; last2 = p2; }\nif (left2 > 0) { cur2 = cur2 + slope2; left2 = left2 - 1; if (left2 <= 0) { cur2 = last2; } }\nf = mtof(cur2 + vibamt + 0.005);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d2 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k2 != lastk2) { lastk2 = k2; wait2 = w2 * sr / 1000; }\nif (wait2 >= 0) {\n    wait2 = wait2 - 1;\n    if (wait2 < 0) { burst2 = per; vel2 = v2; env2 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst2 > 0) { exlp2 = exlp2 + pickc * vel2 * (noise() * vel2 - exlp2); x = exlp2; burst2 = burst2 - 1; }\ny = dl2.read(look, interp=\"cubic\");\nlp2 = (1 - bb) * y + bb * lp2;\ndl2.write(clamp(lp2 * exp(-6.9078 * per / ((d2 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv2 = swelling ? min(1, env2 + swinc) : 1;\ns = y * env2 * env2;\nL = L + s * 0.5;\nR = R + s * 0.866;\n\n\n// string 3\nif (p3 != last3) { n = max(1, g3 * sr / 1000); slope3 = (p3 - cur3) / n; left3 = n; last3 = p3; }\nif (left3 > 0) { cur3 = cur3 + slope3; left3 = left3 - 1; if (left3 <= 0) { cur3 = last3; } }\nf = mtof(cur3 + vibamt + -0.015);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d3 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k3 != lastk3) { lastk3 = k3; wait3 = w3 * sr / 1000; }\nif (wait3 >= 0) {\n    wait3 = wait3 - 1;\n    if (wait3 < 0) { burst3 = per; vel3 = v3; env3 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst3 > 0) { exlp3 = exlp3 + pickc * vel3 * (noise() * vel3 - exlp3); x = exlp3; burst3 = burst3 - 1; }\ny = dl3.read(look, interp=\"cubic\");\nlp3 = (1 - bb) * y + bb * lp3;\ndl3.write(clamp(lp3 * exp(-6.9078 * per / ((d3 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv3 = swelling ? min(1, env3 + swinc) : 1;\ns = y * env3 * env3;\nL = L + s * 0.5878;\nR = R + s * 0.809;\n\n\n// string 4\nif (p4 != last4) { n = max(1, g4 * sr / 1000); slope4 = (p4 - cur4) / n; left4 = n; last4 = p4; }\nif (left4 > 0) { cur4 = cur4 + slope4; left4 = left4 - 1; if (left4 <= 0) { cur4 = last4; } }\nf = mtof(cur4 + vibamt + 0.01);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d4 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k4 != lastk4) { lastk4 = k4; wait4 = w4 * sr / 1000; }\nif (wait4 >= 0) {\n    wait4 = wait4 - 1;\n    if (wait4 < 0) { burst4 = per; vel4 = v4; env4 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst4 > 0) { exlp4 = exlp4 + pickc * vel4 * (noise() * vel4 - exlp4); x = exlp4; burst4 = burst4 - 1; }\ny = dl4.read(look, interp=\"cubic\");\nlp4 = (1 - bb) * y + bb * lp4;\ndl4.write(clamp(lp4 * exp(-6.9078 * per / ((d4 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv4 = swelling ? min(1, env4 + swinc) : 1;\ns = y * env4 * env4;\nL = L + s * 0.6691;\nR = R + s * 0.7431;\n\n\n// string 5\nif (p5 != last5) { n = max(1, g5 * sr / 1000); slope5 = (p5 - cur5) / n; left5 = n; last5 = p5; }\nif (left5 > 0) { cur5 = cur5 + slope5; left5 = left5 - 1; if (left5 <= 0) { cur5 = last5; } }\nf = mtof(cur5 + vibamt + -0.005);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d5 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k5 != lastk5) { lastk5 = k5; wait5 = w5 * sr / 1000; }\nif (wait5 >= 0) {\n    wait5 = wait5 - 1;\n    if (wait5 < 0) { burst5 = per; vel5 = v5; env5 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst5 > 0) { exlp5 = exlp5 + pickc * vel5 * (noise() * vel5 - exlp5); x = exlp5; burst5 = burst5 - 1; }\ny = dl5.read(look, interp=\"cubic\");\nlp5 = (1 - bb) * y + bb * lp5;\ndl5.write(clamp(lp5 * exp(-6.9078 * per / ((d5 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv5 = swelling ? min(1, env5 + swinc) : 1;\ns = y * env5 * env5;\nL = L + s * 0.7431;\nR = R + s * 0.6691;\n\n\n// string 6\nif (p6 != last6) { n = max(1, g6 * sr / 1000); slope6 = (p6 - cur6) / n; left6 = n; last6 = p6; }\nif (left6 > 0) { cur6 = cur6 + slope6; left6 = left6 - 1; if (left6 <= 0) { cur6 = last6; } }\nf = mtof(cur6 + vibamt + 0.015);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d6 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k6 != lastk6) { lastk6 = k6; wait6 = w6 * sr / 1000; }\nif (wait6 >= 0) {\n    wait6 = wait6 - 1;\n    if (wait6 < 0) { burst6 = per; vel6 = v6; env6 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst6 > 0) { exlp6 = exlp6 + pickc * vel6 * (noise() * vel6 - exlp6); x = exlp6; burst6 = burst6 - 1; }\ny = dl6.read(look, interp=\"cubic\");\nlp6 = (1 - bb) * y + bb * lp6;\ndl6.write(clamp(lp6 * exp(-6.9078 * per / ((d6 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv6 = swelling ? min(1, env6 + swinc) : 1;\ns = y * env6 * env6;\nL = L + s * 0.809;\nR = R + s * 0.5878;\n\n\n// string 7\nif (p7 != last7) { n = max(1, g7 * sr / 1000); slope7 = (p7 - cur7) / n; left7 = n; last7 = p7; }\nif (left7 > 0) { cur7 = cur7 + slope7; left7 = left7 - 1; if (left7 <= 0) { cur7 = last7; } }\nf = mtof(cur7 + vibamt + -0.01);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d7 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k7 != lastk7) { lastk7 = k7; wait7 = w7 * sr / 1000; }\nif (wait7 >= 0) {\n    wait7 = wait7 - 1;\n    if (wait7 < 0) { burst7 = per; vel7 = v7; env7 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst7 > 0) { exlp7 = exlp7 + pickc * vel7 * (noise() * vel7 - exlp7); x = exlp7; burst7 = burst7 - 1; }\ny = dl7.read(look, interp=\"cubic\");\nlp7 = (1 - bb) * y + bb * lp7;\ndl7.write(clamp(lp7 * exp(-6.9078 * per / ((d7 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv7 = swelling ? min(1, env7 + swinc) : 1;\ns = y * env7 * env7;\nL = L + s * 0.866;\nR = R + s * 0.5;\n\n\n// string 8\nif (p8 != last8) { n = max(1, g8 * sr / 1000); slope8 = (p8 - cur8) / n; left8 = n; last8 = p8; }\nif (left8 > 0) { cur8 = cur8 + slope8; left8 = left8 - 1; if (left8 <= 0) { cur8 = last8; } }\nf = mtof(cur8 + vibamt + 0.005);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d8 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k8 != lastk8) { lastk8 = k8; wait8 = w8 * sr / 1000; }\nif (wait8 >= 0) {\n    wait8 = wait8 - 1;\n    if (wait8 < 0) { burst8 = per; vel8 = v8; env8 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst8 > 0) { exlp8 = exlp8 + pickc * vel8 * (noise() * vel8 - exlp8); x = exlp8; burst8 = burst8 - 1; }\ny = dl8.read(look, interp=\"cubic\");\nlp8 = (1 - bb) * y + bb * lp8;\ndl8.write(clamp(lp8 * exp(-6.9078 * per / ((d8 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv8 = swelling ? min(1, env8 + swinc) : 1;\ns = y * env8 * env8;\nL = L + s * 0.9135;\nR = R + s * 0.4067;\n\n\n// string 9\nif (p9 != last9) { n = max(1, g9 * sr / 1000); slope9 = (p9 - cur9) / n; left9 = n; last9 = p9; }\nif (left9 > 0) { cur9 = cur9 + slope9; left9 = left9 - 1; if (left9 <= 0) { cur9 = last9; } }\nf = mtof(cur9 + vibamt + -0.015);\nper = sr / f;\nomega = twopi * f / sr;\nbb = d9 > 0 ? bd : b;\nlook = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);\nif (k9 != lastk9) { lastk9 = k9; wait9 = w9 * sr / 1000; }\nif (wait9 >= 0) {\n    wait9 = wait9 - 1;\n    if (wait9 < 0) { burst9 = per; vel9 = v9; env9 = swelling ? 0 : 1; plucked = 1; }\n}\nx = 0;\nif (burst9 > 0) { exlp9 = exlp9 + pickc * vel9 * (noise() * vel9 - exlp9); x = exlp9; burst9 = burst9 - 1; }\ny = dl9.read(look, interp=\"cubic\");\nlp9 = (1 - bb) * y + bb * lp9;\ndl9.write(clamp(lp9 * exp(-6.9078 * per / ((d9 > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));\nenv9 = swelling ? min(1, env9 + swinc) : 1;\ns = y * env9 * env9;\nL = L + s * 0.9511;\nR = R + s * 0.309;\n\nif (plucked) { vibenv = 0; }\ndryl = tanh(L * 0.7);\ndryr = tanh(R * 0.7);\nrin = (dryl + dryr) * 0.04;\nrevsm = revsm + 0.001 * (reverb * 0.01 - revsm);\nwetl = 0;\ncy = cl0.read(1116 * sr / 44100);\ncfl0 = cy * 0.75 + cfl0 * 0.25;\ncl0.write(rin + cfl0 * 0.84);\nwetl = wetl + cy;\ncy = cl1.read(1188 * sr / 44100);\ncfl1 = cy * 0.75 + cfl1 * 0.25;\ncl1.write(rin + cfl1 * 0.84);\nwetl = wetl + cy;\ncy = cl2.read(1277 * sr / 44100);\ncfl2 = cy * 0.75 + cfl2 * 0.25;\ncl2.write(rin + cfl2 * 0.84);\nwetl = wetl + cy;\ncy = cl3.read(1356 * sr / 44100);\ncfl3 = cy * 0.75 + cfl3 * 0.25;\ncl3.write(rin + cfl3 * 0.84);\nwetl = wetl + cy;\nay = al0.read(556 * sr / 44100);\nal0.write(wetl + ay * 0.5);\nwetl = ay - wetl;\nay = al1.read(441 * sr / 44100);\nal1.write(wetl + ay * 0.5);\nwetl = ay - wetl;\nwetr = 0;\ncy = cr0.read(1139 * sr / 44100);\ncfr0 = cy * 0.75 + cfr0 * 0.25;\ncr0.write(rin + cfr0 * 0.84);\nwetr = wetr + cy;\ncy = cr1.read(1211 * sr / 44100);\ncfr1 = cy * 0.75 + cfr1 * 0.25;\ncr1.write(rin + cfr1 * 0.84);\nwetr = wetr + cy;\ncy = cr2.read(1300 * sr / 44100);\ncfr2 = cy * 0.75 + cfr2 * 0.25;\ncr2.write(rin + cfr2 * 0.84);\nwetr = wetr + cy;\ncy = cr3.read(1379 * sr / 44100);\ncfr3 = cy * 0.75 + cfr3 * 0.25;\ncr3.write(rin + cfr3 * 0.84);\nwetr = wetr + cy;\nay = ar0.read(579 * sr / 44100);\nar0.write(wetr + ay * 0.5);\nwetr = ay - wetr;\nay = ar1.read(464 * sr / 44100);\nar1.write(wetr + ay * 0.5);\nwetr = ay - wetr;\nvolsm = volsm + 0.001 * (dbtoa(volume) * volpedal - volsm);\noutl = (dryl + wetl * revsm) * volsm;\noutr = (dryr + wetr * revsm) * volsm;\ndcyl = outl - dcxl + 0.995 * dcyl; dcxl = outl;\ndcyr = outr - dcxr + 0.995 * dcyr; dcxr = outr;\nout1 = tanh(dcyl);\nout2 = tanh(dcyr);\n",
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
					"annotation": "Volume-pedal swell on every note: 0 = normal pick attack, higher = notes fade in.",
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
					"annotation": "How long a held string rings.",
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
								12000.0
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
					"annotation": "Dark and mellow to bright and glassy.",
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
								60.0
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