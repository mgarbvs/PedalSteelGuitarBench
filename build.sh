#!/usr/bin/env bash
# build.sh — test, emit m4l/PedalSteel.maxpat, check it, assemble m4l/PedalSteel.amxd (instrument).
set -euo pipefail
cd "$(dirname "$0")"
TOOLS=../MaxForLiveTools
NAM=../NAMMaxInstrument_CombinedOnly/scripts

node tests/test_brain.js
node tests/test_neck.js > /dev/null
python3 scripts/build_maxpat.py m4l/PedalSteel.maxpat
node scripts/check_genexpr.js m4l/PedalSteel.maxpat 2>&1 | grep -v "^parse failed" | grep -v "^    at " || true
node scripts/check_genexpr.js m4l/PedalSteel.maxpat > /dev/null 2>&1
node tests/test_engine.js
python3 $NAM/validate_maxpat.py m4l/PedalSteel.maxpat
python3 $TOOLS/build_amxd.py m4l/PedalSteel.maxpat m4l/PedalSteel.amxd --type iiii
