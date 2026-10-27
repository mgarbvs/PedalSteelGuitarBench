#!/usr/bin/env python3
"""build_sampler.py — emit m4l/SampleSteel.maxpat: the pedal steel's brain, neck and pedals playing a
dropped-in sample instead of Karplus-Strong strings (source of truth; never hand-edit the output).

    live.drop → buffer~ ---smp ─(info~ sample rate)─► gen~ @smp ---smp (10 sample voices + spring reverb)
    everything else (MIDI → steel_brain.js → gen~ / steel_neck.js, knobs, pedals) is build_maxpat.build()
"""
import json
import math
import os
import sys

import build_maxpat as bm

DEVICE_W = 940
VOICE_GAIN = 0.35   # a full-scale sample per voice; ten of them still sit under the amp's tanh

# One sample voice per steel string. Pitch glides exactly like a string (the brain sends the same
# p/g/k/v/w/d messages); playback speed follows it, so bends and bar slides bend the sample.
VOICE = """
// voice {i}
if (p{i} != last{i}) {{ n = max(1, g{i} * sr / 1000); slope{i} = (p{i} - cur{i}) / n; left{i} = n; last{i} = p{i}; }}
if (left{i} > 0) {{ cur{i} = cur{i} + slope{i}; left{i} = left{i} - 1; if (left{i} <= 0) {{ cur{i} = last{i}; }} }}
if (k{i} != lastk{i}) {{ lastk{i} = k{i}; wait{i} = w{i} * sr / 1000; }}
if (wait{i} >= 0) {{
    wait{i} = wait{i} - 1;
    if (wait{i} < 0) {{
        ofade{i} = amp{i} > 0.00001; oamp{i} = amp{i} * env{i} * env{i}; opos{i} = pos{i};   // the ringing note fades out
        pos{i} = 0; amp{i} = v{i} * v{i}; env{i} = swelling ? 0 : 1; plucked = 1;
    }}
}}
y = 0; o = 0;
if (amp{i} > 0.00001) {{
    inc = mtof(cur{i} + vibamt + {detune}) * ratek;
    y = peek(smp, pos{i}, 0, interp="spline", boundmode="ignore");
    if (xfading && pos{i} > xfstart) {{   // equal-power crossfade into the loop start: no click at the seam
        fade = min(1, (pos{i} - xfstart) / xf);   // past End (knob moved, shorter sample): >1 → sqrt NaN → silence
        y = y * sqrt(1 - fade) + peek(smp, pos{i} - ll, 0, interp="spline", boundmode="ignore") * sqrt(fade);
    }}
    if (ofade{i} > 0) {{   // re-picked while ringing: the old note keeps playing under the new one for 5 ms
        o = peek(smp, opos{i}, 0, interp="spline", boundmode="ignore");
        if (xfading && opos{i} > xfstart) {{
            fade = min(1, (opos{i} - xfstart) / xf);
            o = o * sqrt(1 - fade) + peek(smp, opos{i} - ll, 0, interp="spline", boundmode="ignore") * sqrt(fade);
        }}
        o = o * oamp{i} * ofade{i};
        opos{i} = opos{i} + inc;
        if (looping && opos{i} >= lw) {{ opos{i} = opos{i} - ll; }}
        ofade{i} = ofade{i} - ofinc;
    }}
    pos{i} = pos{i} + inc;
    if (looping && pos{i} >= lw) {{ pos{i} = pos{i} - ll; }}
    if (pos{i} >= len) {{ amp{i} = 0; }}   // one-shot: the note ends with the sample
    amp{i} = amp{i} * (d{i} > 0 ? relk : susk);
}}
env{i} = swelling ? min(1, env{i} + swinc) : 1;
s = (y * amp{i} * env{i} * env{i} + o) * {gain};
{expr}
L = L + s * {gl};
R = R + s * {gr};
"""


def gen_code():
    decl = [
        "Param vib(0.25);", "Param sustain(30000);", "Param tone(100);", "Param swell(0);",
        "Param blockall(0);",   # the brain's palm block; sample voices already fade on release
        "Param root(60);", "Param fine(0);", "Param loop(1);", "Param lstart(0.3);", "Param lend(0.9);",
        "Param smpsr(44100);",
        'Buffer smp("smp");',   # bound to the device's buffer~ by the gen~ box: @smp ---smp
        "History vibph(0);", "History vibenv(0);", "History tlpl(0);", "History tlpr(0);",
    ]
    for i, o in enumerate(bm.OPEN):
        decl += [
            f"Param p{i}({o});", f"Param g{i}(0);", f"Param k{i}(0);", f"Param v{i}(0.8);",
            f"Param w{i}(0);", f"Param d{i}(1);",
            f"History cur{i}({o});", f"History last{i}({o});", f"History slope{i}(0);", f"History left{i}(0);",
            f"History lastk{i}(0);", f"History wait{i}(-1);", f"History env{i}(1);",
            f"History pos{i}(0);", f"History amp{i}(0);",
            f"History opos{i}(0);", f"History oamp{i}(0);", f"History ofade{i}(0);",
        ] + bm.expr_decl(i)
    out_decl, out_body = bm.output_stage()
    decl += out_decl

    body = [
        "sr = samplerate;",
        "n = 0; y = 0; o = 0; inc = 0; s = 0; fade = 0; plucked = 0; L = 0; R = 0;",
        "vibph = wrap(vibph + 5.5 / sr, 0, 1);",
        "vibenv = min(1, vibenv + 1 / (0.7 * sr));",
        "vibamt = sin(vibph * twopi) * vib * 0.3 * vibenv;",   # bar vibrato, up to ±0.3 semitone
        "swelling = swell > 1;",
        "swinc = 1 / max(1, swell * sr / 1000);",
        "len = dim(smp);",
        "ratek = smpsr / sr / mtof(root + fine / 100);",      # buffer samples per output sample, per Hz
        "ls = min(lstart, lend) * len;",
        "le = max(lstart, lend) * len;",
        "ll = le - ls;",
        "looping = loop > 0.5 && ll > 100;",
        "xfcap = min(ll * 0.5, 0.05 * smpsr);",                # up to 50 ms
        "xfpre = min(xfcap, ls);",                             # room before Start: fade End into the audio before it
        "xfpost = min(xfcap, len - le);",                      # none (Start at 0): fade the audio after End into Start
        "xf = max(xfpre, xfpost);",
        "xfading = looping && xf >= 1;",
        "lw = xfpost > xfpre ? le + xf : le;",                 # wrap point: past End when the fade uses the audio after it
        "xfstart = lw - xf;",
        "ofinc = 1 / (0.005 * sr);",                           # re-pick: the old note fades out in 5 ms
        "relk = exp(-6.9078 / (0.15 * sr));",                  # key up: 60 dB down in 150 ms
        "susk = sustain >= 29999 ? 1 : exp(-6.9078 / (sustain * sr / 1000));",   # fully up = never fades
    ]
    for i in range(10):
        theta = (0.5 + 0.3 * (4.5 - i) / 4.5) * math.pi / 2     # string 1 right, string 10 left
        body.append(VOICE.format(i=i, expr=bm.EXPR.format(i=i), detune=bm.DETUNE_CENTS[i] / 100, gain=VOICE_GAIN,
                                 gl=round(math.cos(theta), 4), gr=round(math.sin(theta), 4)))
    body += [
        "if (plucked) { vibenv = 0; }",
        "tonek = 1 - exp(-twopi * 200 * pow(2, tone * 0.066) / sr);",   # low-pass 200 Hz → ~19 kHz
        "tlpl = tlpl + tonek * (L - tlpl); L = tlpl;",
        "tlpr = tlpr + tonek * (R - tlpr); R = tlpr;",
    ]
    body += out_body
    return "\n".join(decl) + "\n" + "\n".join(body) + "\n"


SOUND = [
    ("swell", "Swell", "Swell", 0, 2000, 0, 2, "swell",
     "Volume-pedal swell on every note: 0 = the sample's own attack, higher = notes fade in.", 2.0),
    ("sustain", "Sustain", "Sustain", 2000, 30000, 30000, 2, "sustain",
     "How long a held note takes to fade. Fully up, held notes never fade (with Loop on).", 1.0),
    ("tone", "Tone", "Tone", 0, 100, 100, 5, "tone",
     "Low-pass filter: dark and muffled to fully open.", 1.0),
    bm.SOUND[3], bm.SOUND[4],   # Reverb, Volume
]


def sample_card():
    """SAMPLE card: drop zone, Loop, Root, Fine, loop Start/End. Returns the ids to bang on load."""
    bm.panel("sample_card", [740, 4, 196, 158])
    bm.comment("sample_lbl", "SAMPLE", [746, 6, 60, 18], size=11, bold=True)
    bm.add(id="drop", maxclass="live.drop", varname="drop", numinlets=1, numoutlets=2, outlettype=["", ""],
           parameter_enable=1, legend="Drop a sample", annotation_name="Sample",
           annotation="Drop an audio file here (from Live's browser or Finder). Every string plays it, "
                      "pitched by the Root knob, so pedals bend it and the bar slides it. Single held "
                      "notes work best: a bowed violin, a sung vowel, an organ.",
           patching_rect=[1640, 520, 184, 56], **bm.pres([746, 26, 184, 20]),
           saved_attribute_attributes={"valueof": {
               "parameter_longname": "Sample", "parameter_shortname": "Sample", "parameter_type": 4,
               "parameter_invisible": 1, "parameter_modmode": 0}})
    bm.obj("skip_none", "route none", 1640, 580, ins=2, outs=2, outtype=["", ""])   # empty drop banged on load says "none"
    bm.obj("pre_replace", "prepend replace", 1640, 600)
    bm.obj("smpbuf", "buffer~ ---smp", 1640, 630, ins=1, outs=2, outtype=["float", "bang"])
    bm.obj("smpinfo", "info~ ---smp", 1640, 660, ins=2, outs=10)
    bm.obj("pre_smpsr", "prepend smpsr", 1640, 690)
    bm.wire("drop", "skip_none")
    bm.wire("skip_none", "pre_replace", 1)
    bm.wire("pre_replace", "smpbuf")
    bm.wire("smpbuf", "smpinfo", 1)          # file read done → report its sample rate
    bm.wire("smpinfo", "pre_smpsr", 0)
    bm.wire("pre_smpsr", "engine")

    bm.add(id="loop", maxclass="live.text", varname="loop", numinlets=1, numoutlets=2, outlettype=["", ""],
           parameter_enable=1, mode=1, text="Loop", texton="Loop", annotation_name="Loop",
           annotation="On: held notes loop the section between Start and End, so they sustain and "
                      "bend for as long as you hold them (bowed and sustained sounds). Off: the "
                      "sample plays once and ends (plucked and struck sounds).",
           patching_rect=[1760, 506, 50, 16], **bm.pres([880, 8, 50, 15]),
           saved_attribute_attributes={"valueof": {
               "parameter_longname": "Loop", "parameter_shortname": "Loop", "parameter_type": 2,
               "parameter_enum": ["Off", "On"], "parameter_mmax": 1,
               "parameter_initial_enable": 1, "parameter_initial": [1]}})
    bm.obj("pre_loop", "prepend loop", 1760, 540)
    bm.wire(bm.push_toggle("loop"), "pre_loop")
    bm.wire("pre_loop", "engine")

    dials = [
        ("root", "Root", "Root", 0, 127, 60, 8, "root",
         "The note the sample was recorded at. Set it to the sample's pitch so every string plays in tune.", 1.0),
        ("fine", "Fine", "Fine", -50, 50, 0, 0, "fine",
         "Fine tuning of the sample in cents, for recordings that sit between notes.", 1.0),
        ("lstart", "Loop Start", "Start", 0, 100, 30, 5, "lstart",
         "Where the loop begins, as a % of the sample. Put it after the attack.", 1.0),
        ("lend", "Loop End", "End", 0, 100, 90, 5, "lend",
         "Where the loop ends, as a % of the sample. Put it before the note dies away.", 1.0),
    ]
    for j, (bid, ln, sn, lo, hi, init, us, msg, info, ex) in enumerate(dials):
        bm.dial(bid, ln, sn, [746 + j * 47, 108, 44, 48], lo, hi, init, us, info, ex)
        pct = msg in ("lstart", "lend")
        bm.obj(f"pre_{bid}", f"prepend {msg}", 1760 + j * 110, 580)
        if pct:   # % → 0..1
            bm.obj(f"scale_{bid}", "* 0.01", 1760 + j * 110, 560)
            bm.wire(bid, f"scale_{bid}")
            bm.wire(f"scale_{bid}", f"pre_{bid}")
        else:
            bm.wire(bid, f"pre_{bid}")
        bm.wire(f"pre_{bid}", "engine")

    # waveform of the dropped sample; the loop Start/End is its selection (ms = fraction * sample length)
    bm.add(id="wave", maxclass="waveform~", numinlets=5, numoutlets=6, outlettype=["float", "float", "float", "float", "list", "list"],
           buffername="---smp", labels=0, ticks=0, vticks=0, vlabels=0, ignoreclick=1,
           gridcolor=[0, 0, 0, 0], labeltextcolor=[0, 0, 0, 0], labelbgcolor=[0, 0, 0, 0],
           bgcolor=[0.1, 0.1, 0.1, 1], waveformcolor=[0.96, 0.68, 0.34, 1], selectioncolor=[0.96, 0.68, 0.34, 0.25],
           annotation_name="Waveform", annotation="The dropped sample. The lit section is the loop (Start to End).",
           patching_rect=[1640, 740, 184, 56], **bm.pres([746, 48, 184, 56]))
    bm.obj("len_t", "t b b f", 1640, 720, outs=3, outtype=["bang", "bang", "float"])
    bm.wire("smpinfo", "len_t", 6)           # new sample: length in ms, then re-send both fractions
    for bid, inlet in (("lstart", 2), ("lend", 3)):
        bm.obj(f"frac_{bid}", "f", 1760, 740 + inlet * 30, ins=2, outs=1, outtype=["float"])
        bm.obj(f"ms_{bid}", "* 1.", 1760, 770 + inlet * 30, ins=2, outs=1, outtype=["float"])
        bm.wire(f"scale_{bid}", f"frac_{bid}")
        bm.wire(f"frac_{bid}", f"ms_{bid}")
        bm.wire("len_t", f"ms_{bid}", 2, 1)
        bm.wire(f"ms_{bid}", "wave", 0, inlet)
    bm.wire("len_t", "frac_lend", 0)
    bm.wire("len_t", "frac_lstart", 1)
    return ["drop", "loop_menu"] + [d[0] for d in dials]


def build():
    return bm.build(code=gen_code(), sound=SOUND, width=DEVICE_W, engine_text="gen~ @smp ---smp",
                    extra=sample_card, extra_bank="Sample",
                    description="Pedal steel playing any sample: drop in a sound, play chords, get steel.")


if __name__ == "__main__":
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "m4l", "SampleSteel.maxpat")
    with open(out, "w") as f:
        json.dump(build(), f, indent="\t")
    print(f"Wrote {out}")
