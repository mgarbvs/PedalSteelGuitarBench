# TODO: realism

Ordered by audible payoff per line of code. Judge each by ear from an on/off WAV pair of a
full-chord phrase rendered through the brain (`node tests/test_engine.js out.wav`), not from
single-string tests.

## Tone
- [ ] **Speaker.** After the `tanh` in `output_stage()` (`scripts/build_maxpat.py`) the signal is
  full-bandwidth. Steel amps are clean with 12–15" speakers: high-pass near 80 Hz, steep low-pass
  near 4–5 kHz, maybe a small 2–3 kHz peak. Two biquads. `output_stage()` is shared, so
  SampleSteel and InputSteel get it too; decide whether they should.

## Pitch
- [ ] **Sweetened tuning.** `OPEN` and `CHANGES` in `m4l/steel_brain.js` are whole semitones, so
  major thirds beat like a keyboard. Players tune thirds about 14 cents flat (G# strings, the
  A-pedal C#, and so on) for beatless triads. Add a cents table per open string and per pedal
  change inside `target()`; leave the solver's integer pitch matching alone. It will sound
  slightly flat against equal-tempered instruments, so make the amount one constant to tune by
  ear, like `CAB_DROP` (or a knob if that turns out to matter).
- [ ] **Eased glides.** The pitch ramp in the `STRING` template is linear in semitones and every
  string moves in lockstep, which reads as synth portamento. Ease the bar in and out (smoothstep),
  let pedals land against a stop (ease-out), and jitter each string's glide time about ±15% in
  `sendPitches()`. SampleSteel and InputSteel have their own ramps.
- [ ] **Bar scoop.** Slide into some fresh chords from a fret or so below. The `pre` mechanism
  that does the pedal "cry" in `solve()` can do the same for the bar.
- [ ] **Humanised vibrato.** It is a fixed 5.5 Hz sine (`vibph`/`vibenv` in `gen_code()`). Add
  slow random drift in rate and depth, and vary the onset delay.

## Player
- [ ] **Volume-pedal riding.** Players pick with the pedal backed off and push it forward as the
  note dies: soft attack, flat sustain. Swell only fades in. A slow auto-gain (level follower with
  capped make-up gain) in the output stage would emulate it.
- [ ] **Picking.** Every string gets the key velocity and exact Strum spacing (end of `solve()`).
  Add a darker, slightly early thumb on the low strings, small velocity and timing jitter, and a
  brief damp when a ringing string is picked again.

## String physics (costlier, do last)
- [ ] **Two polarizations per string.** Slow shimmer and two-stage decay on sustained notes.
  Doubles the delay lines and the CPU.
- [ ] **Wound versus plain strings.** All ten strings share one loss filter (`b`); strings 7–10
  should be duller and slightly inharmonic. An allpass for inharmonicity fights the ±1 cent
  tuning test.
- [ ] **Bar scrape.** Tried once and it turned into fuzz on chords and fast slides. Only worth
  retrying on the wound strings, band-limited, at a much lower level, checked with 3+ strings
  sounding.
