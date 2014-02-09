#!/bin/bash
#
# NOTE. For this file to be useful, it must be sourced, i.e,
# $> source env.sh
# $> . env.sh
#
#------------------------------------------------------------------------------
# Env. var used if set:
#
# DART_BASE: directory assumed to contain subdirectories dart-sdk and chromium
#            (e.g., as for a dart editor installation).
#
# Env. var used if set, but otherwise this script will attempt to set them:

# DART_SDK: path to a dart-sdk directory.
# DARTSDK:  alternative for DART_SDK (for backwards compatibility).

set -e

# The preferred way of finding what we need.
if [ -d "$DART_BASE" ]; then
    : ${DART_SDK:=$DART_BASE/dart-sdk}
    : ${DARTIUM:=$DART_BASE/chromium}
fi

if [ -d "$DART_SDK" ]; then
    : ${DARTSDK=$DART_SDK}
elif [ ! -d  "$DART_SDK" ] && [ -d "$DARTSDK" ]; then
    : ${DART_SDK:=$DARTSDK}
fi

# If we still don't have a handle on the dart-sdk, try to guess it.
# FIXME
if [ ! -d "$DART_SDK" ]; then
    echo "=== "
    DART=`which dart|cat` # pipe to cat to ignore the exit code
    DART_SDK=`which dart | sed -e 's/\/dart\-sdk\/.*$/\/dart-sdk/'`

    if [ "$DART_SDK" == "/Applications/dart/dart-sdk" ]; then
        # Assume we are a mac machine with standard dart setup
        export DARTIUM="/Applications/dart/chromium/Chromium.app/Contents/MacOS/Chromium"
    else
        DARTSDK="`pwd`/dart-sdk"
        case $( uname -s ) in
          Darwin)
            export DARTIUM=${DARTIUM:-./dartium/Chromium.app/Contents/MacOS/Chromium}
            ;;
          Linux)
            export DARTIUM=${DARTIUM:-./dartium/chrome}
            ;;
        esac
    fi
fi

export DART_SDK="$DARTSDK"
export DART=${DART:-"$DARTSDK/bin/dart"}
export PUB=${PUB:-"$DARTSDK/bin/pub"}
export DARTANALYZER=${DARTANALYZER:-"$DARTSDK/bin/dartanalyzer"}
export DARTDOC=${DARTDOC:-"$DARTSDK/bin/dartdoc"}


export CHROME_CANARY_BIN=${CHROME_CANARY_BIN:-"$DARTIUM"}
export CHROME_BIN=${CHROME_BIN:-"google-chrome"}
export DART_FLAGS='--enable_type_checks --enable_asserts'

if [ -d "$DARTSDK/bin" ] && [[ ! "$PATH" =~ (^|:)"$DARTSDK/bin"(:|$) ]]; then
    PATH+=":$DARTSDK/bin"
fi
