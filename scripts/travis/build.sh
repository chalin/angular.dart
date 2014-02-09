#!/bin/bash
# File: travis/build.sh

set -e

[ -n "$DART_BUILD_VERBOSE" ] && set -v
[ -n "$DART_BUILD_TRACE"   ] && set -x

: ${SCRIPT_DIR:=$(dirname $0)/..}
. "$SCRIPT_DIR/env.sh"

echo "#=============================================================================="
echo "Running io tests:"
dart -c test/io/all.dart

./scripts/generate-expressions.sh
echo "#=============================================================================="
./scripts/analyze.sh

echo "#=============================================================================="
echo "Running release/changelog tests:"
./node_modules/jasmine-node/bin/jasmine-node ./scripts/changelog/

echo "#=============================================================================="
echo "Running karma:"
./node_modules/jasmine-node/bin/jasmine-node playback_middleware/spec/ &&
  node "node_modules/karma/bin/karma" start karma.conf \
    --reporters=junit,dots --port=8765 --runner-port=8766 \
    --browsers=Dartium,ChromeNoSandbox --single-run --no-colors --no-color

echo "#=============================================================================="
echo "Generating documentation:"
./scripts/generate-documentation.sh -q

