#!/usr/bin/env python3
"""build_input.py — emit m4l/InputSteel.maxpat: an audio effect that turns whatever plays into it
into a pedal steel. Chords come from a MIDI track picked with MIDI From (source of truth; never
hand-edit the output).

    plugin~ ─┬─► gen~ in1/in2 (10 pitch-shifted voices of the input + spring reverb) → plugout~
             └─► +~ → fzero~ ---hz───► gen~ inhz (the input's pitch, so every voice shifts to its note)
    live.routing (MIDI From) → midiin → steel_brain.js → gen~ / steel_neck.js: build_maxpat.build()
"""
import json
import math
import os
import sys

import build_maxpat as bm

DEVICE_W = 940
VOICE_GAIN = 0.7    # a full-scale input per voice; ten of them still sit under the limiter (tests/test_input.js)

# One pitch shifter per steel string, all reading one delay line of the input. Two taps half a
# window apart sweep through the delay at (1 - ratio) and crossfade with sin² windows (which sum to 1),
# so each voice plays the input at ratio = string note / input pitch. The window is two input
# periods, so the two taps stay in phase and don't beat, and it follows the pitch smoothly (a
# whole-period count that steps as the pitch moves would jump the taps and click).
VOICE = """
// voice {i}
if (p{i} != last{i}) {{ n = max(1, g{i} * sr / 1000); slope{i} = (p{i} - cur{i}) / n; left{i} = n; last{i} = p{i}; }}
if (left{i} > 0) {{ cur{i} = cur{i} + slope{i}; left{i} = left{i} - 1; if (left{i} <= 0) {{ cur{i} = last{i}; }} }}
if (k{i} != lastk{i}) {{ lastk{i} = k{i}; wait{i} = w{i} * sr / 1000; }}
if (wait{i} >= 0) {{
    wait{i} = wait{i} - 1;
    if (wait{i} < 0) {{ amp{i} = v{i} * v{i}; env{i} = swelling ? 0 : 1; plucked = 1; }}
}}
y = 0;
if (amp{i} > 0.00001) {{
    ph{i} = wrap(ph{i} + (1 - mtof(cur{i} + vibamt + {detune}) / hzsm) / win, 0, 1);
    pb = wrap(ph{i} + 0.5, 0, 1);
    wa = sin(pi * ph{i});
    wb = sin(pi * pb);
    y = inp.read(ph{i} * win + 1, interp="cubic") * wa * wa + inp.read(pb * win + 1, interp="cubic") * wb * wb;
    amp{i} = amp{i} * (d{i} > 0 ? relk : susk);
}}
env{i} = swelling ? min(1, env{i} + swinc) : 1;
s = y * amp{i} * env{i} * env{i} * {gain};
L = L + s * {gl};
R = R + s * {gr};
"""


def gen_code():
    decl = [
        "Param vib(0.25);", "Param sustain(30000);", "Param tone(100);", "Param swell(0);",
        "Param blockall(0);",   # the brain's palm block; voices already fade on release
        "Param inhz(220);",     # fzero~'s pitch of the input
        "Param dry(0);",
        "Delay inp(8192);",
        "History hzsm(220);", "History vibph(0);", "History vibenv(0);", "History tlpl(0);", "History tlpr(0);",
    ]
    for i, o in enumerate(bm.OPEN):
        decl += [
            f"Param p{i}({o});", f"Param g{i}(0);", f"Param k{i}(0);", f"Param v{i}(0.8);",
            f"Param w{i}(0);", f"Param d{i}(1);",
            f"History cur{i}({o});", f"History last{i}({o});", f"History slope{i}(0);", f"History left{i}(0);",
            f"History lastk{i}(0);", f"History wait{i}(-1);", f"History env{i}(1);",
            f"History amp{i}(0);", f"History ph{i}(0);",
        ]
    out_decl, out_body = bm.output_stage()
    decl += out_decl

    body = [
        "sr = samplerate;",
        "n = 0; y = 0; s = 0; pb = 0; wa = 0; wb = 0; plucked = 0; L = 0; R = 0;",
        "inp.write((in1 + in2) * 0.5);",
        "hzsm = hzsm + 0.002 * (clamp(inhz, 30, 2000) - hzsm);",   # ~10 ms smoothing of the tracker's steps
        "per = sr / hzsm;",
        "win = 2 * per;",                                          # taps one input period apart
        "vibph = wrap(vibph + 5.5 / sr, 0, 1);",
        "vibenv = min(1, vibenv + 1 / (0.7 * sr));",
        "vibamt = sin(vibph * twopi) * vib * 0.3 * vibenv;",   # bar vibrato, up to ±0.3 semitone
        "swelling = swell > 1;",
        "swinc = 1 / max(1, swell * sr / 1000);",
        "relk = exp(-6.9078 / (0.15 * sr));",                  # key up: 60 dB down in 150 ms
        "susk = sustain >= 29999 ? 1 : exp(-6.9078 / (sustain * sr / 1000));",   # fully up = never fades
    ]
    for i in range(10):
        theta = (0.5 + 0.3 * (4.5 - i) / 4.5) * math.pi / 2     # string 1 right, string 10 left
        body.append(VOICE.format(i=i, detune=bm.DETUNE_CENTS[i] / 100, gain=VOICE_GAIN,
                                 gl=round(math.cos(theta), 4), gr=round(math.sin(theta), 4)))
    body += [
        "if (plucked) { vibenv = 0; }",
        "tonek = 1 - exp(-twopi * 200 * pow(2, tone * 0.066) / sr);",   # low-pass 200 Hz → ~19 kHz
        "tlpl = tlpl + tonek * (L - tlpl); L = tlpl;",
        "tlpr = tlpr + tonek * (R - tlpr); R = tlpr;",
    ]
    body += out_body
    body += ["out1 = out1 + in1 * dry;", "out2 = out2 + in2 * dry;"]   # the untouched input, after the amp
    return "\n".join(decl) + "\n" + "\n".join(body) + "\n"


SOUND = [
    ("swell", "Swell", "Swell", 0, 2000, 0, 2, "swell",
     "Volume-pedal swell on every note: 0 = the input's own attack, higher = notes fade in.", 2.0),
    ("sustain", "Sustain", "Sustain", 2000, 30000, 30000, 2, "sustain",
     "How long a held note takes to fade. Fully up, held notes last as long as the input does.", 1.0),
    ("tone", "Tone", "Tone", 0, 100, 100, 5, "tone",
     "Low-pass filter: dark and muffled to fully open.", 1.0),
    bm.SOUND[3], bm.SOUND[4],   # Reverb, Volume
]

UMENU = dict(maxclass="umenu", numinlets=1, numoutlets=3, outlettype=["int", "", ""], parameter_enable=0,
             allowdrag=0, fontname="Ableton Sans Medium", fontsize=9.5, bgcolor=[1, 1, 1, 0],
             bgfillcolor_type="color", bgfillcolor_color=[0.2, 0.2, 0.2, 1.0],
             textcolor=[1.0, 0.71, 0.2, 1.0], items=[])


def input_card():
    """INPUT card: MIDI From (type + channel), Dry. Plus the audio path. Returns the ids to bang on load."""
    bm.panel("input_card", [740, 4, 196, 158])
    bm.comment("input_lbl", "INPUT", [746, 6, 60, 18], size=11, bold=True)
    bm.comment("midifrom_lbl", "MIDI From (plays the chords)", [746, 26, 184, 16])

    # Audio in: to the engine, and summed to mono for the pitch tracker.
    bm.obj("plugin", "plugin~", 1640, 300, ins=2, outs=2, outtype=["signal", "signal"])
    bm.obj("insum", "+~", 1640, 340, ins=2, outs=1, outtype=["signal"])
    bm.obj("fzero", "fzero~ @freqmin 40 @freqmax 1500", 1640, 380, ins=1, outs=3, outtype=["", "", ""])
    bm.obj("pre_inhz", "prepend inhz", 1640, 420)
    bm.wire("plugin", "engine", 0, 0)
    bm.wire("plugin", "engine", 1, 1)
    bm.wire("plugin", "insum", 0, 0)
    bm.wire("plugin", "insum", 1, 1)
    bm.wire("insum", "fzero")
    bm.wire("fzero", "pre_inhz", 0)
    bm.wire("pre_inhz", "engine")

    # MIDI From: live.routing's midi_inputs port, as in Cycling '74's "live.routing Midi-In" snippet.
    # The umenus aren't Live parameters; Live keeps the device's routing itself.
    bm.add(id="msg_port", maxclass="message", text="port midi_inputs", numinlets=2, numoutlets=1,
           outlettype=[""], patching_rect=[1640, 460, 110, 22])
    bm.obj("routing", "live.routing", 1640, 490, ins=1, outs=5, w=160)
    bm.wire("msg_port", "routing")
    for kind, rect, outs in (("type", [746, 42, 184, 20], (0, 2)), ("channel", [746, 64, 184, 20], (1, 3))):
        bm.add(id=f"menu_{kind}", annotation_name="MIDI From",
               annotation="The MIDI track or keyboard that plays the chords. The sound comes from this "
                          "track's audio; the chords come from here." if kind == "type" else
                          "Which point of the MIDI source to listen to.",
               patching_rect=[1640 + (0 if kind == "type" else 200), 580, 184, 20], **bm.pres(rect), **UMENU)
        bm.obj(f"clr_{kind}", "t l clear", 1640 + (0 if kind == "type" else 200), 520, ins=1, outs=2)
        bm.obj(f"iter_{kind}", "iter", 1640 + (0 if kind == "type" else 200), 540)
        bm.obj(f"app_{kind}", "prepend append", 1640 + (0 if kind == "type" else 200), 560)
        bm.obj(f"set_{kind}", "prepend setsymbol", 1740 + (0 if kind == "type" else 200), 560)
        bm.add(id=f"msg_{kind}", maxclass="message", text=f"{kind} $1", numinlets=2, numoutlets=1,
               outlettype=[""], patching_rect=[1640 + (0 if kind == "type" else 200), 610, 70, 22])
        bm.wire("routing", f"clr_{kind}", outs[1])        # available list → clear, then append each
        bm.wire(f"clr_{kind}", f"menu_{kind}", 1)
        bm.wire(f"clr_{kind}", f"iter_{kind}", 0)
        bm.wire(f"iter_{kind}", f"app_{kind}")
        bm.wire(f"app_{kind}", f"menu_{kind}")
        bm.wire("routing", f"set_{kind}", outs[0])        # current choice → show it
        bm.wire(f"set_{kind}", f"menu_{kind}")
        bm.wire(f"menu_{kind}", f"msg_{kind}", 0)         # user picks → route
        bm.wire(f"msg_{kind}", "routing")

    bm.dial("dry", "Dry", "Dry", [746, 108, 44, 48], 0, 100, 0, 5,
            "How much of the untouched input plays alongside the steel.", 1.0)
    bm.obj("scale_dry", "* 0.01", 1760, 560)
    bm.obj("pre_dry", "prepend dry", 1760, 580)
    bm.wire("dry", "scale_dry")
    bm.wire("scale_dry", "pre_dry")
    bm.wire("pre_dry", "engine")
    return ["msg_port", "dry"]


def build():
    return bm.build(code=gen_code(), sound=SOUND, width=DEVICE_W, extra=input_card, engine_ins=2,
                    amxdtype=1633771873,   # 'aaaa' = audio effect
                    description="Pedal steel from any instrument: its audio, voiced and bent by chords from a MIDI track.")


if __name__ == "__main__":
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "m4l", "InputSteel.maxpat")
    with open(out, "w") as f:
        json.dump(build(), f, indent="\t")
    print(f"Wrote {out}")
