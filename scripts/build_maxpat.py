#!/usr/bin/env python3
"""build_maxpat.py — emit m4l/PedalSteel.maxpat (source of truth; never hand-edit the output).

    midiin → midiparse → steel_brain.js ─┬─► gen~ (10 waveguide strings + reverb) → plugout~
                                         └─► steel_neck.js (jsui neck + pedal board)
    steel_neck.js mouse → brain (pluck / pedal) or → Bar dial (drag)
    live.dials → brain (playing feel) or → gen~ (sound)
"""
import json
import os
import sys

OPEN = [66, 63, 68, 64, 59, 56, 54, 52, 50, 47]      # E9, strings 1..10
DETUNE_CENTS = [1.5, -1, 0.5, -1.5, 1, -0.5, 1.5, -1, 0.5, -1.5]
PICKUP_FRAC = 1 / 14     # pickup distance from the bridge as a fraction of the open string (about 1.7" of 24"); tune by ear
PICKUP_GAIN = 0.81       # make-up gain after the comb: keeps levels where they were without the pickup
PICKUP_RES_HZ = 4000     # coil resonance; tune by ear
PICKUP_RES_Q = 1.5
PICK_FRAC = 0.2          # where the right hand picks: distance from the bridge as a fraction of the open string (about 4.8" of 24"); tune by ear
PICK_NOISE = 0.1         # pick scratch: noise mixed into the pluck, so no two picks are identical
PICK_GAIN = 0.32         # pick level: keeps overall levels where they were with the old noise pick
DEVICE_W = 740

# ── Gen~ engine ─────────────────────────────────────────────────────────────
# One Karplus-Strong waveguide per string: a delay line whose length follows a
# gliding pitch (so the bar and pedals bend ringing strings), a one-pole loss
# filter, a noise-burst pick, and a per-note "volume pedal" swell envelope.

# MPE per string: x = pressure level, t = slide brightness (tilt around ~1 kHz; 0.5 = flat), smoothed ~10 ms.
EXPR = """xs{i} = xs{i} + 0.002 * (x{i} - xs{i}); ts{i} = ts{i} + 0.002 * (t{i} - ts{i});
tl{i} = tl{i} + 0.15 * (s - tl{i});
s = (tl{i} + (s - tl{i}) * exp2(ts{i} * 3 - 1.5)) * xs{i};"""


def expr_decl(i):
    return [f"Param x{i}(1);", f"Param t{i}(0.5);", f"History xs{i}(1);", f"History ts{i}(0.5);", f"History tl{i}(0);"]


STRING = """
// string {i}
if (p{i} != last{i}) {{ n = max(1, g{i} * sr / 1000); slope{i} = (p{i} - cur{i}) / n; left{i} = n; last{i} = p{i}; }}
if (left{i} > 0) {{ cur{i} = cur{i} + slope{i}; left{i} = left{i} - 1; if (left{i} <= 0) {{ cur{i} = last{i}; }} }}
// sympathetic resonance: the AVERAGE of every OTHER string's previous sample (never itself, so a
// lone ringing string can't detune/feed itself), lowpassed then DC-blocked. DC-blocking is essential:
// without it a steady/near-DC component would recirculate through a near-lossless string forever
// and rail the delay line (verified by ear/measurement, not just caution).
othersum = (symsum - lasts{i}) * 0.1111;
symlp{i} = symlp{i} + 0.3 * (othersum - symlp{i});
symhp{i} = symhp{i} + 0.01 * (symlp{i} - symhp{i});
coup{i} = symlp{i} - symhp{i};
f = mtof(cur{i} + vibamt + {detune});
per = sr / f;
omega = twopi * f / sr;
// a damp (d 0→1) blocks the string for 0.4 s, then it's open again to ring along sympathetically
if (d{i} != lastd{i}) {{ lastd{i} = d{i}; blk{i} = d{i} > 0 ? 0.4 * sr : 0; }}
if (blkall && d{i} > 0) {{ blk{i} = 0.4 * sr; }}
blk{i} = max(0, blk{i} - 1);
bb = blk{i} > 0 ? bd : b;
look = clamp(per - atan2(bb * sin(omega), 1 - bb * cos(omega)) / omega, 2, 8190);
if (k{i} != lastk{i}) {{ lastk{i} = k{i}; wait{i} = w{i} * sr / 1000; }}
if (wait{i} >= 0) {{
    wait{i} = wait{i} - 1;
    if (wait{i} < 0) {{ burst{i} = per; vel{i} = v{i}; pol{i} = noise() < 0 ? -1 : 1; env{i} = swelling ? 0 : 1; plucked = 1; }}
}}
x = 0;
pkr = clamp({pkd} * sr / per, 0.1, 0.5);    // the pick point as a fraction of the sounding string (never past the middle)
pkn = pkr * per;                            // samples of the period spent on the "high" level
pkx = 0;
if (burst{i} > 0) {{
    pkx = ((pol{i} * (burst{i} <= pkn ? 1 : -pkn / (per - pkn))) * (1 - pkr) / sin(twopi * 0.5 * pkr) + {pknoise} * noise()) * vel{i} * {pkgain};
    burst{i} = burst{i} - 1;
}}
exlp{i} = exlp{i} + pickc * vel{i} * (pkx - exlp{i});
x = exlp{i};
y = dl{i}.read(look, interp="cubic");
yd = dl{i}.read(look + {pud} * sr, interp="cubic");
lp{i} = (1 - bb) * y + bb * lp{i};
dl{i}.write(clamp((lp{i} + (blk{i} > 0 ? 0 : coup{i} * 0.008)) * exp(-6.9078 * per / ((blk{i} > 0 ? 150 : sustain) * sr / 1000)) + x, -4, 4));
env{i} = swelling ? min(1, env{i} + swinc) : 1;
sy = y * env{i} * env{i} * xs{i};                     // the string itself: feeds the sympathetic bus (strings couple at the bridge, before the pickup)
s = (y - yd) * {pugain} * env{i} * env{i};      // what the pickup hears
{expr}
L = L + s * {gl};
R = R + s * {gr};
lasts{i} = sy;
symacc = symacc + sy;
"""

# Pedal board hover/click zones: transparent live.text toggles laid over the pedals that
# steel_neck.js draws (same geometry as its pedalRects() at 470×158, plus the jsui's 4px offset).
PEDALS = [
    ("A", 38, 30, "Raises strings 5 and 10 from B to C#. Pressed together with B, it turns the open E "
                  "chord into A: the classic pedal steel sound."),
    ("B", 72, 30, "Raises strings 3 and 6 from G# to A. Pressed together with A, it turns the open E "
                  "chord into A: the classic pedal steel sound."),
    ("C", 106, 30, "Raises string 4 from E to F# and string 5 from B to C#. Pressed with B, it turns the "
                   "E chord into F# minor."),
    ("LKL", 150, 36, "Left knee lever, pushed left: raises both E strings (4 and 8) a half step to F."),
    ("LKR", 190, 36, "Left knee lever, pushed right: lowers both E strings (4 and 8) a half step to D#."),
    ("RKL", 230, 36, "Right knee lever, pushed left: raises both F# strings (1 and 7) a half step to G."),
    ("RKR", 270, 36, "Right knee lever, pushed right: lowers string 2 from D# to D and string 9 from D to C#. "
                     "Good for bluesy 7th-chord sounds."),
]
PEDAL_HOW = (" Click to hold it down, click again to let go. In Chords mode the pedals also press "
             "themselves when a chord needs them (outlined = pressed for this chord, solid = latched by you, solid with a white border = latched and this chord uses it).")
CLEAR = [0.0, 0.0, 0.0, 0.0]

STEREO_SPREAD = 23

# Spring reverb: a short feedback loop (bulk delay, slightly modulated + band-limited)
# followed by a short allpass chain (dispersion -> the spring's metallic "boing/drip").
# L/R are decorrelated with different bulk-delay lengths, LFO rates and allpass offsets.
SPRING_BASE_MS = {"l": 34.0, "r": 45.0}    # loop bulk delay per side (ms) -> tune the "boing" length
SPRING_MOD_MS = 1.2                        # slow modulation depth on the bulk delay, avoids metallic buildup
SPRING_MOD_HZ = {"l": 0.13, "r": 0.19}     # decorrelated modulation rates
SPRING_FB = 0.85                           # loop feedback: ~2 s to -60 dB, like a long Twin-style tank; must stay < 1
SPRING_AP = [71, 97, 127, 157, 191, 223]   # allpass dispersion chain, samples @ 44100
SPRING_AP_G = 0.6                          # allpass coefficient (dispersion amount)


def gen_code():
    import math
    decl = [
        "Param vib(0.25);", "Param sustain(12000);", "Param tone(60);", "Param swell(0);",
        "Param blockall(0);", "History lastba(0);", "History vibph(0);", "History vibenv(0);",
    ]
    for i, o in enumerate(OPEN):
        decl += [
            f"Param p{i}({o});", f"Param g{i}(0);", f"Param k{i}(0);", f"Param v{i}(0.8);",
            f"Param w{i}(0);", f"Param d{i}(1);",
            f"Delay dl{i}(8192);",
            f"History cur{i}({o});", f"History last{i}({o});", f"History slope{i}(0);", f"History left{i}(0);",
            f"History lastk{i}(0);", f"History wait{i}(-1);", f"History burst{i}(0);", f"History pol{i}(1);", f"History vel{i}(0);",
            f"History env{i}(1);", f"History lp{i}(0);", f"History exlp{i}(0);", f"History lastd{i}(1);", f"History blk{i}(0);",
            f"History lasts{i}(0);", f"History symlp{i}(0);", f"History symhp{i}(0);",
        ] + expr_decl(i)
    decl.append("History symsum(0);")   # sympathetic-resonance bus: raw sum of last sample's string outputs
    for ch in "lr":   # pickup coil resonance (biquad low-pass): past two inputs and outputs per channel
        decl += [f"History pux{ch}1(0);", f"History pux{ch}2(0);", f"History puy{ch}1(0);", f"History puy{ch}2(0);"]
    out_decl, out_body = output_stage()
    decl += out_decl

    body = [
        "sr = samplerate;",
        "n = 0; f = 0; per = 0; omega = 0; bb = 0; look = 0; x = 0; y = 0; yd = 0; s = 0; sy = 0; plucked = 0; L = 0; R = 0; pkr = 0; pkn = 0; pkx = 0;"
        " symacc = 0; othersum = 0;",
        "blkall = blockall != lastba; lastba = blockall;",   # palm block: the brain bumps it when the last key lifts
        "vibph = wrap(vibph + 5.5 / sr, 0, 1);",
        "vibenv = min(1, vibenv + 1 / (0.7 * sr));",
        "vibamt = sin(vibph * twopi) * vib * 0.3 * vibenv;",   # bar vibrato, up to ±0.3 semitone
        "b = 1 - (0.3 + 0.0065 * tone);",                      # loop filter: higher tone = brighter
        "bd = 1 - (0.3 + 0.0065 * tone) * 0.6;",               # damped strings go dark too
        "pickc = 0.15 + 0.008 * tone;",
        "swelling = swell > 1;",
        "swinc = 1 / max(1, swell * sr / 1000);",
    ]
    for i in range(10):
        theta = (0.5 + 0.3 * (4.5 - i) / 4.5) * math.pi / 2     # string 1 right, string 10 left
        f_open = 440 * 2 ** ((OPEN[i] - 69) / 12)
        body.append(STRING.format(i=i, expr=EXPR.format(i=i), detune=DETUNE_CENTS[i] / 100,
                                  pud=round(PICKUP_FRAC / f_open, 9), pugain=PICKUP_GAIN,
                                  pkd=round(PICK_FRAC / f_open, 9), pknoise=PICK_NOISE, pkgain=PICK_GAIN,
                                  gl=round(math.cos(theta), 4), gr=round(math.sin(theta), 4)))
    body += [
        "if (plucked) { vibenv = 0; }",
        "symsum = symacc;",   # sympathetic bus: this sample's total, ready for next sample's "other strings" sum
    ]
    # pickup coil resonance: RBJ low-pass biquad on L and R (this device only, not in output_stage)
    body += [
        f"puom = twopi * {PICKUP_RES_HZ} / sr;",
        f"pual = sin(puom) / (2 * {PICKUP_RES_Q});",
        "puc = cos(puom);",
        "pub0 = (1 - puc) / 2; pub1 = 1 - puc;",
        "pua0 = 1 + pual; pua1 = -2 * puc; pua2 = 1 - pual;",
    ]
    for ch in "lr":
        X = ch.upper()
        body += [
            f"pux{ch}0 = {X};",
            f"puy{ch}0 = (pub0 * pux{ch}0 + pub1 * pux{ch}1 + pub0 * pux{ch}2 - pua1 * puy{ch}1 - pua2 * puy{ch}2) / pua0;",
            f"pux{ch}2 = pux{ch}1; pux{ch}1 = pux{ch}0; puy{ch}2 = puy{ch}1; puy{ch}1 = puy{ch}0; {X} = puy{ch}0;",
        ]
    body += out_body
    return "\n".join(decl) + "\n" + "\n".join(body) + "\n"


def output_stage():
    """Amp, spring reverb and output limiter: turns the voices' L/R sums into out1/out2 (shared by every engine)."""
    decl = [
        "Param reverb(30);", "Param volume(0);", "Param volpedal(1);",
        "History volsm(1);", "History revsm(0.3);",
        "History dcxl(0);", "History dcyl(0);", "History dcxr(0);", "History dcyr(0);",
    ]
    for side in "lr":
        decl += [f"Delay rvd{side}(8192);", f"History rvlfo{side}(0);",
                 f"History rvlp{side}(0);", f"History rvhp{side}(0);"]
        for j in range(len(SPRING_AP)):
            decl.append(f"Delay rva{side}{j}(8192);")
    body = [
        "dryl = tanh(L * 0.7);",           # a clean amp that only breaks up on big strums
        "dryr = tanh(R * 0.7);",
        "rin = (dryl + dryr) * 0.04;",
        "revsm = revsm + 0.001 * (reverb * 0.01 - revsm);",
    ]
    for side, off in (("l", 0), ("r", STEREO_SPREAD)):
        body += [
            f"rvlfo{side} = wrap(rvlfo{side} + {SPRING_MOD_HZ[side]} / sr, 0, 1);",
            f"rvlen{side} = ({SPRING_BASE_MS[side]} + {SPRING_MOD_MS} * sin(rvlfo{side} * twopi)) * sr / 1000;",
            f"rvloopy{side} = rvd{side}.read(rvlen{side}, interp=\"cubic\");",
            f"rvlp{side} = rvloopy{side} * 0.45 + rvlp{side} * 0.55;",     # lowpass -> keeps loop under ~4-5 kHz
            f"rvhp{side} = rvhp{side} + 0.013 * (rvlp{side} - rvhp{side});",
            f"rvband{side} = rvlp{side} - rvhp{side};",                    # highpass -> loses below ~100 Hz
        ]
        apnode = f"rvband{side}"
        for j, ln in enumerate(SPRING_AP):
            outnode = f"rvap{side}{j}"
            body += [
                f"rvy{side}{j} = rva{side}{j}.read({ln + off} * sr / 44100);",
                # true (unity-gain) Schroeder allpass: v[n]=x+g*bufout, y=bufout-g*v[n] (NOT bufout-x,
                # which is the common "freeverb" shortcut but has gain (1+g) per stage -> unstable in a loop)
                f"rvv{side}{j} = {apnode} + rvy{side}{j} * {SPRING_AP_G};",
                f"rva{side}{j}.write(rvv{side}{j});",
                f"{outnode} = rvy{side}{j} - {SPRING_AP_G} * rvv{side}{j};",
            ]
            apnode = outnode
        body += [
            f"rvd{side}.write(clamp(rin + {apnode} * {SPRING_FB}, -4, 4));",
            f"wet{side} = {apnode};",
        ]
    body += [
        "volsm = volsm + 0.001 * (dbtoa(volume) * volpedal - volsm);",
        "outl = (dryl + wetl * revsm) * volsm;",
        "outr = (dryr + wetr * revsm) * volsm;",
        "dcyl = outl - dcxl + 0.995 * dcyl; dcxl = outl;",   # DC blocker
        "dcyr = outr - dcxr + 0.995 * dcyr; dcxr = outr;",
        "out1 = tanh(dcyl);",              # soft limit, never a hard digital clip
        "out2 = tanh(dcyr);",
    ]
    return decl, body


# ── Patcher helpers ─────────────────────────────────────────────────────────

boxes, lines = [], []


def add(**kw):
    boxes.append({"box": kw})
    return kw["id"]


def obj(bid, text, x, y, ins=1, outs=1, outtype=None, w=None, **kw):
    return add(id=bid, maxclass="newobj", text=text, numinlets=ins, numoutlets=outs,
               outlettype=outtype if outtype is not None else [""] * outs,
               patching_rect=[x, y, w or max(40, 7 * len(text)), 22], **kw)


def wire(src, dst, outlet=0, inlet=0):
    lines.append({"patchline": {"source": [src, outlet], "destination": [dst, inlet]}})


def pres(rect):
    return dict(presentation=1, presentation_rect=rect)


def comment(bid, text, rect, size=10, bold=False, color=None):
    kw = dict(fontname="Ableton Sans Bold" if bold else "Ableton Sans Medium", fontsize=size)
    if color:
        kw["textcolor"] = color
    return add(id=bid, maxclass="comment", text=text, numinlets=1, numoutlets=0,
               patching_rect=[rect[0] + 900, rect[1] + 500, rect[2], rect[3]], **pres(rect), **kw)


def panel(bid, rect):  # background=1: always drawn behind controls (else earlier boxes draw on top)
    return add(id=bid, maxclass="panel", numinlets=1, numoutlets=0, bgcolor=[0.14, 0.14, 0.14, 1.0],
               rounded=4, background=1, patching_rect=[rect[0] + 900, rect[1] + 500, rect[2], rect[3]], **pres(rect))


def dial(bid, longname, short, rect, lo, hi, init, unitstyle, info, exponent=1.0):
    valueof = {
        "parameter_longname": longname, "parameter_shortname": short, "parameter_type": 0,
        "parameter_mmin": float(lo), "parameter_mmax": float(hi),
        "parameter_initial_enable": 1, "parameter_initial": [float(init)],
        "parameter_unitstyle": unitstyle,
    }
    if exponent != 1.0:
        valueof["parameter_exponent"] = exponent
    return add(id=bid, maxclass="live.dial", varname=bid, numinlets=1, numoutlets=2,
               outlettype=["", "float"], parameter_enable=1, annotation_name=longname, annotation=info,
               patching_rect=[rect[0] + 900, rect[1] + 500, rect[2], rect[3]], **pres(rect),
               saved_attribute_attributes={"valueof": valueof})


def push_toggle(bid):
    """Push shows a live.text toggle as val1/val2; only live.menu surfaces Off/On. So the visible
    toggle becomes a stored-only "<name> UI" parameter and a hidden live.menu takes over its longname
    (automation, Push). Wire consumers and the load bang from the returned menu id."""
    box = next(b["box"] for b in boxes if b["box"]["id"] == bid)
    v = box["saved_attribute_attributes"]["valueof"]
    mid = bid + "_menu"
    x, y = box["patching_rect"][:2]
    add(id=mid, maxclass="live.menu", varname=mid, hidden=1, numinlets=1, numoutlets=3,
        outlettype=["", "", "float"], parameter_enable=1, patching_rect=[x, y + 60, 60, 20],
        saved_attribute_attributes={"valueof": dict(v)})
    v["parameter_longname"] += " UI"
    v["parameter_invisible"] = 1
    obj(f"set_{bid}", "prepend set", x, y + 90)
    wire(bid, mid)                 # click → parameter
    wire(mid, f"set_{bid}")        # parameter (Push, automation, load) → display, without output
    wire(f"set_{bid}", bid)
    return mid


def param_banks(banks):
    """Baked Push banks: (name, [box ids]) → the patcher's "parameters" registry. Banks longer than
    8 continue on "<name> 2"."""
    params = {b["box"]["id"]: b["box"]["saved_attribute_attributes"]["valueof"] for b in boxes
              if b["box"].get("parameter_enable")}
    reg = {bid: [v["parameter_longname"], v["parameter_shortname"], 0] for bid, v in params.items()}
    reg["parameterbanks"] = {}
    for name, ids in banks:
        for k in range(0, len(ids), 8):
            names = [params[i]["parameter_longname"] for i in ids[k:k + 8]]
            n = len(reg["parameterbanks"])
            reg["parameterbanks"][str(n)] = {"index": n, "name": name + (f" {k // 8 + 1}" if k else ""),
                                             "parameters": names + ["-"] * (8 - len(names)), "buttons": ["-"] * 8}
    reg["inherited_shortname"] = 1
    return reg


# ── Build ───────────────────────────────────────────────────────────────────

SOUND = [
    ("swell", "Swell", "Swell", 0, 2000, 0, 2, "swell",
     "Volume-pedal swell on every note: 0 = normal pick attack, higher = notes fade in.", 2.0),
    ("sustain", "Sustain", "Sustain", 2000, 30000, 12000, 2, "sustain",
     "How long a held string rings.", 1.0),
    ("tone", "Tone", "Tone", 0, 100, 60, 5, "tone",
     "Dark and mellow to bright and glassy.", 1.0),
    ("reverb", "Reverb", "Reverb", 0, 100, 30, 5, "reverb",
     "Amp-style room reverb.", 1.0),
    ("volume", "Volume", "Vol", -40, 6, 0, 4, "volume",
     "Output level. An expression pedal (CC 11) works as the steel's volume pedal.", 1.0),
]


def build(code=None, sound=None, width=DEVICE_W, engine_text="gen~", extra=None, extra_bank=None,
          description="Pedal steel guitar: play chords, get steel.", engine_ins=0, amxdtype=1768515945):
    """extra(): adds device-specific boxes and returns the ids to bang on load. Its visible parameters
    get their own Push bank named extra_bank, or join the Sound bank when that's None.
    engine_ins: gen~ audio inlets (in 1..n). amxdtype: 'iiii' instrument (default) or 'aaaa' audio effect."""
    code = code or gen_code()
    sound = sound or SOUND
    # MIDI in → brain
    obj("thisdev", "live.thisdevice", 20, 20, ins=1, outs=3, outtype=["bang", "int", "int"])
    obj("midiin", "midiin", 20, 60)
    obj("midiparse", "midiparse @hires 1", 20, 90, ins=1, outs=8, outtype=["", "", "", "int", "int", "int", "int", ""])
    obj("pre_note", "prepend note", 20, 130)
    obj("pre_cc", "prepend cc", 130, 130)
    obj("pre_bend", "prepend bend", 240, 130)
    obj("brain", "js steel_brain.js", 20, 220, ins=1, outs=2, w=160)
    wire("midiin", "midiparse")
    wire("midiparse", "pre_note", 0)
    wire("midiparse", "pre_cc", 2)
    wire("midiparse", "pre_bend", 5)
    obj("pre_touch", "prepend touch", 350, 130)    # channel pressure (MPE)
    obj("pre_chan", "prepend chan", 460, 130)      # fires before each message: the brain's MPE channel
    wire("midiparse", "pre_touch", 4)
    wire("midiparse", "pre_chan", 6)
    wire("pre_touch", "brain")
    wire("pre_chan", "brain")
    for p in ("pre_note", "pre_cc", "pre_bend"):
        wire(p, "brain")

    # Engine
    gen_patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.gen", "rect": [100.0, 100.0, 700.0, 700.0],
        "boxes": [
            {"box": {"id": "code", "maxclass": "codebox", "code": code, "fontface": 0,
                     "fontname": "<Monospaced>", "fontsize": 12.0, "numinlets": engine_ins, "numoutlets": 2,
                     "outlettype": ["", ""], "patching_rect": [20.0, 20.0, 640.0, 560.0]}},
            {"box": {"id": "out1", "maxclass": "newobj", "text": "out 1", "numinlets": 1, "numoutlets": 0,
                     "patching_rect": [20.0, 600.0, 40.0, 22.0]}},
            {"box": {"id": "out2", "maxclass": "newobj", "text": "out 2", "numinlets": 1, "numoutlets": 0,
                     "patching_rect": [620.0, 600.0, 40.0, 22.0]}},
        ],
        "lines": [
            {"patchline": {"source": ["code", 0], "destination": ["out1", 0]}},
            {"patchline": {"source": ["code", 1], "destination": ["out2", 0]}},
        ],
    }
    for i in range(engine_ins):
        gen_patcher["boxes"].append({"box": {"id": f"in{i + 1}", "maxclass": "newobj", "text": f"in {i + 1}",
                                             "numinlets": 0, "numoutlets": 1, "outlettype": [""],
                                             "patching_rect": [20.0 + 60 * i, 0.0, 40.0, 22.0]}})
        gen_patcher["lines"].append({"patchline": {"source": [f"in{i + 1}", 0], "destination": ["code", i]}})
    obj("engine", engine_text, 20, 300, ins=max(1, engine_ins), outs=2, outtype=["signal", "signal"], w=160, patcher=gen_patcher)
    obj("plugout", "plugout~", 20, 360, ins=2, outs=0, outtype=[])
    wire("brain", "engine", 0)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)

    # Pedal/lever buttons: added before the neck so they sit on top of it (earlier = frontmost).
    for name, x, w, info in PEDALS:
        bid = "ped_" + name
        add(id=bid, maxclass="live.text", varname=bid, numinlets=1, numoutlets=2, outlettype=["", ""],
            parameter_enable=1, mode=1, text="", texton="", annotation_name=f"{name} " +
            ("Pedal" if len(name) == 1 else "Knee Lever"), annotation=info + PEDAL_HOW,
            bgcolor=CLEAR, bgoncolor=CLEAR, activebgcolor=CLEAR, activebgoncolor=CLEAR,
            bordercolor=CLEAR, focusbordercolor=CLEAR, textcolor=CLEAR, activetextcolor=CLEAR,
            activetextoncolor=CLEAR, textoncolor=CLEAR,
            patching_rect=[x + 900, 700, w, 20], **pres([x + 4, 118, w, 20]),
            saved_attribute_attributes={"valueof": {
                "parameter_longname": f"Pedal {name}", "parameter_shortname": name, "parameter_type": 2,
                "parameter_enum": ["Off", "On"], "parameter_mmax": 1,
                "parameter_initial_enable": 1, "parameter_initial": [0]}})
        obj(f"pre_{bid}", f"prepend pedal {name}", x + 900, 740)
        wire(push_toggle(bid), f"pre_{bid}")
        wire(f"pre_{bid}", "brain")

    # Neck display (the big clickable steel)
    add(id="neck", maxclass="jsui", filename="steel_neck.js", varname="neck", numinlets=1, numoutlets=1,
        outlettype=[""], border=0, parameter_enable=0, annotation_name="Pedal Steel",
        annotation="The steel: strings light up as they ring, the chrome bar shows where the "
                   "slide is, and the pedals/levers light when they bend a string. Click a string "
                   "to pick it, drag across the neck to slide the bar, click a pedal or lever to engage it.",
        patching_rect=[300, 220, 470, 158], **pres([4, 4, 470, 158]))
    wire("brain", "neck", 1)
    obj("neck_route", "route bar", 300, 400, ins=2, outs=2)
    wire("neck", "neck_route")
    wire("neck_route", "brain", 1)            # pluck / pedal messages

    # PLAY card
    panel("play_card", [480, 4, 256, 76])
    comment("play_lbl", "PLAY", [486, 6, 60, 18], size=11, bold=True)
    add(id="mode", maxclass="live.tab", varname="mode", numinlets=1, numoutlets=3,
        outlettype=["", "", "float"], parameter_enable=1, num_lines_patching=1, num_lines_presentation=1, annotation_name="Mode",
        annotation="Chords: play anything on your keyboard and it is voiced like a steel player "
                   "would, with automatic bar slides and pedal bends. Strings: play the real "
                   "instrument — white keys C3–E4 pick strings, C2–B2 hold pedals and levers.",
        patching_rect=[480 + 900, 504, 104, 18], **pres([580, 7, 104, 17]),
        saved_attribute_attributes={"valueof": {
            "parameter_longname": "Mode", "parameter_shortname": "Mode", "parameter_type": 2,
            "parameter_enum": ["Chords", "Strings"], "parameter_mmax": 1,
            "parameter_initial_enable": 1, "parameter_initial": [0]}})
    obj("pre_mode", "prepend mode", 480, 20)
    wire("mode", "pre_mode")
    wire("pre_mode", "brain")
    add(id="mpe", maxclass="live.text", varname="mpe", numinlets=1, numoutlets=2, outlettype=["", ""],
        parameter_enable=1, mode=1, text="MPE", texton="MPE", annotation_name="MPE",
        annotation="On: each note's own pitch bend, pressure and slide (Push 3, Seaboard, Linnstrument…) "
                   "bend, swell and brighten just its string. Off: every MIDI channel plays like an "
                   "ordinary keyboard, and pitch bend moves the bar.",
        patching_rect=[640 + 900, 504, 42, 18], **pres([688, 7, 42, 17]),
        saved_attribute_attributes={"valueof": {
            "parameter_longname": "MPE", "parameter_shortname": "MPE", "parameter_type": 2,
            "parameter_enum": ["Off", "On"], "parameter_mmax": 1,
            "parameter_initial_enable": 1, "parameter_initial": [1]}})
    obj("pre_mpe", "prepend mpe", 640, 20)
    wire(push_toggle("mpe"), "pre_mpe")
    wire("pre_mpe", "brain")

    play = [
        ("bar", "Bar", "Bar", 0, 22, 0, 1, "bar",
         "Where the steel bar sits, in frets. Turn it while strings ring to slide. "
         "In Chords mode the bar also moves by itself to fit each chord.", 1.0),
        ("slide", "Slide", "Slide", 20, 1000, 180, 2, "slide",
         "How long bar slides and pedal bends take when you change chords legato.", 2.0),
        ("strum", "Strum", "Strum", 0, 80, 12, 2, "strum",
         "Time between strings when a chord is picked. 0 = all at once.", 1.0),
        ("bendin", "Bend In", "BendIn", 0, 100, 40, 5, "bendin",
         "How often chords are picked unpedaled and then bent up into place — the classic "
         "pedal steel cry. Higher also makes the player reach for pedals more.", 1.0),
        ("vibrato", "Vibrato", "Vib", 0, 100, 25, 5, "vibrato",
         "Bar vibrato that fades in on held notes. The mod wheel adds more.", 1.0),
    ]
    for i, (bid, ln, sn, lo, hi, init, us, msg, info, ex) in enumerate(play):
        dial(bid, ln, sn, [484 + i * 50, 28, 46, 48], lo, hi, init, us, info, ex)
        obj(f"pre_{bid}", f"prepend {msg}", 600 + i * 110, 60)
        wire(bid, f"pre_{bid}")
        wire(f"pre_{bid}", "brain")
    wire("neck_route", "bar", 0)             # dragging on the neck turns the Bar knob

    # SOUND card
    panel("sound_card", [480, 84, 256, 78])
    comment("sound_lbl", "SOUND", [486, 86, 60, 18], size=11, bold=True)
    for i, (bid, ln, sn, lo, hi, init, us, msg, info, ex) in enumerate(sound):
        dial(bid, ln, sn, [484 + i * 50, 108, 46, 48], lo, hi, init, us, info, ex)
        obj(f"pre_{bid}", f"prepend {msg}", 600 + i * 110, 100)
        wire(bid, f"pre_{bid}")
        wire(f"pre_{bid}", "engine")
    obj("pre_ring", "prepend ring", 600, 140)   # the brain re-picks sliding strings only once they've faded
    wire("sustain", "pre_ring")
    wire("pre_ring", "brain")
    extra_bids = extra() if extra else []

    # On load: push every control's value, then let the brain draw the neck.
    obj("load_trig", "t b b", 20, 180, ins=1, outs=2, outtype=["bang", "bang"])
    add(id="msg_init", maxclass="message", text="init", numinlets=2, numoutlets=1, outlettype=[""],
        patching_rect=[20, 200, 40, 22])
    add(id="msg_bang", maxclass="message", text="bang", numinlets=2, numoutlets=1, outlettype=[""],
        patching_rect=[80, 200, 40, 22])
    wire("thisdev", "load_trig")
    wire("load_trig", "msg_init", 0)          # right-to-left: controls first, then init
    wire("load_trig", "msg_bang", 1)
    wire("msg_init", "brain")
    pedal_ids = ["ped_" + p[0] + "_menu" for p in PEDALS]
    for bid in ["mode", "mpe_menu"] + pedal_ids + [p[0] for p in play + sound] + extra_bids:
        wire("msg_bang", bid)

    # Push: one encoder page each for playing, sound and the pedals (latch them from the encoders).
    extra_params = [b for b in extra_bids if any(x["box"]["id"] == b and x["box"].get("parameter_enable") and
                    not x["box"]["saved_attribute_attributes"]["valueof"].get("parameter_invisible") for x in boxes)]
    banks = [("Play", [p[0] for p in play] + ["mode", "mpe_menu"]),
             ("Sound", [p[0] for p in sound] + ([] if extra_bank else extra_params)),
             ("Pedals", pedal_ids)] + ([(extra_bank, extra_params)] if extra_bank else [])

    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box",
        "rect": [80.0, 80.0, 1700.0, 900.0],
        "openrect": [0.0, 0.0, float(width), 169.0],
        "openinpresentation": 1,
        "devicewidth": float(width),
        "default_fontname": "Ableton Sans Medium",
        "default_fontsize": 10.0,
        "gridsize": [8.0, 8.0],
        "editing_bgcolor": [0.32, 0.29, 0.25, 1.0],
        "description": description,
        "boxes": boxes,
        "lines": lines,
        "parameters": param_banks(banks),
        "dependency_cache": [],
        "autosave": 0,
        # Max's project system needs this block (without it: "a project without a name is like a
        # day without sunshine. fatal."). Copied from a Max-saved device; amxdtype 'iiii' = instrument.
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": amxdtype, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    return {"patcher": patcher}


if __name__ == "__main__":
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "m4l", "PedalSteel.maxpat")
    with open(out, "w") as f:
        json.dump(build(), f, indent="\t")
    print(f"Wrote {out}")
