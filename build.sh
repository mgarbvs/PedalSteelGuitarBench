#!/usr/bin/env bash
# build.sh — test, emit m4l/PedalSteel.maxpat, SampleSteel.maxpat (instruments) and InputSteel.maxpat (audio effect),
# check them, assemble the .amxd files.
set -euo pipefail
cd "$(dirname "$0")"
TOOLS=../MaxForLiveTools
NAM=../NAMMaxInstrument_CombinedOnly/scripts

node tests/test_brain.js
node tests/test_neck.js > /dev/null
python3 scripts/build_maxpat.py m4l/PedalSteel.maxpat
python3 scripts/build_sampler.py m4l/SampleSteel.maxpat
python3 scripts/build_input.py m4l/InputSteel.maxpat
for dev in PedalSteel SampleSteel InputSteel; do
  node scripts/check_genexpr.js m4l/$dev.maxpat 2>&1 | grep -v "^parse failed" | grep -v "^    at " || true
  node scripts/check_genexpr.js m4l/$dev.maxpat > /dev/null 2>&1
done
node tests/test_engine.js
node tests/test_sampler.js
node tests/test_input.js
for dev in PedalSteel SampleSteel; do
  python3 $NAM/validate_maxpat.py m4l/$dev.maxpat
  python3 $TOOLS/build_amxd.py m4l/$dev.maxpat m4l/$dev.amxd --type iiii
done
python3 $NAM/validate_maxpat.py m4l/InputSteel.maxpat
python3 $TOOLS/build_amxd.py m4l/InputSteel.maxpat m4l/InputSteel.amxd --type aaaa
