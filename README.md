# Pedal Steel (Max for Live instrument)

A 10-string E9 pedal steel guitar for Ableton Live that you can play without ever having touched one.
Play chords on a keyboard; it voices them like a steel player would: one bar position plus pedals
and knee levers. Change chords legato and the strings **bend** (pedals) or **slide** (bar) into the new chord.

Listen: `docs/demo.wav` (E major → legato A major pedal bend → slide up to C), rendered from the actual engine code.

## Install
Copy everything in `m4l/` into one folder (e.g. your User Library) and drag `PedalSteel.amxd` onto a MIDI track.
The `.js` files must stay next to the `.amxd`.

## Playing
| | Chords mode (default) | Strings mode (the real instrument) |
|---|---|---|
| Keys | Any notes/chords. Out-of-range notes fold into the steel's range | White keys C3–E4 pick strings 10→1 |
| Pedals | Chosen automatically; hold one on the display to bend by hand | White keys C2–B2 hold A, B, C, LKL, LKR, RKL, RKR |
| Bar | Moves by itself; the Bar knob / dragging the neck slides it | Bar knob / drag the neck |
| Legato | Hold notes into the next chord → bends and slides | — |

In both modes: pitch bend slides the bar ±2 frets, mod wheel adds vibrato, CC 64 sustains, and CC 11 is the volume pedal.
Click any string on the display to pick it.

Knobs: **Bar, Slide** (glide time), **Strum**, **Bend In** (how often chords are picked unpedaled then bent up: the steel "cry"),
**Vibrato**, **Swell** (volume-pedal fade-in per note), **Sustain, Tone, Reverb, Volume**. Every control has Info View help.

## Build
```bash
./build.sh
```
This runs the tests, generates `m4l/PedalSteel.maxpat` from `scripts/build_maxpat.py` (the source of truth; never hand-edit
the `.maxpat`/`.amxd`), syntax-checks the gen~ code against Cycling '74's GenExpr grammar, validates it, and packs the `.amxd`.
Uses `../MaxForLiveTools/build_amxd.py` and `../NAMMaxInstrument_CombinedOnly/scripts/validate_maxpat.py`.

| File | What |
|---|---|
| `m4l/steel_brain.js` | MIDI → voicing solver (bar fret × pedal combos), legato bends/slides, Strings mode |
| `m4l/steel_neck.js` | jsui: neck, bar, pedal board; mouse picking, bar drag, and momentary pedals |
| `scripts/build_maxpat.py` | Patch + gen~ engine (10 Karplus-Strong strings with gliding pitch, swell, bar vibrato, amp, reverb) |
| `tests/test_engine.js` | Runs the generated gen~ code in Node: tuning (±1 cent), glides, headroom, damping, swell |
