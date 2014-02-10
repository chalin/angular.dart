#!/bin/bash
# File: generate-documentation.sh

set -e

function usage() {
    echo "usage: $(basename $0) [option]"
    echo "  -q 		quite mode; overrides value of DART_BUILD_VERBOSE."
    echo "  -h		help"
}

# Assume verbose by default
: ${DART_BUILD_VERBOSE:=1}

#------------------------------------------------------------------------------
# Main:

: ${SCRIPT_DIR:=$(dirname $0)}
. "$SCRIPT_DIR/env.sh"

while [ $# -ne 0 ]; do
    case $1 in
	-q) unset DART_BUILD_VERBOSE;
	    break
	    ;;
	-h) usage;;
	-*) echo "Invalid option: $1";
	    usage;
	    return 0;;
    esac
    shift;
done

: ${TMP:=./tmp}
[ -d "$TMP" ] || mkdir -p "$TMP"

DD_OUT="$TMP/$(basename $0)-out.txt"

echo "Doc generation informational messages saved to $DD_OUT"

$DARTDOC \
    --package-root=packages/ \
    --out doc \
    --mode=static \
    --exclude-lib=js,metadata,meta,mirrors,intl,number_symbols,number_symbol_data,intl_helpers,date_format_internal,date_symbols,angular.util \
    packages/angular/angular.dart lib/mock/module.dart \
    > "$DD_OUT"

if [ -n "$DART_BUILD_VERBOSE" ]; then
    cat "$DD_OUT"
else
    # Print summary when in quite mode
    tail -4 "$DD_OUT"
fi
