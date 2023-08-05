#!/bin/sh
# needs: hurl, ffprobe
set -o pipefail

source "$(dirname "$0")/helpers.sh"

[ "$1" = "" ] && {
    echo "usage: $0 <hostname>" >&2
    echo "pre-req: host must use HTTPS" >&2
    exit 1
}

HOST="$1"

hurl --variable host="$HOST" --test tests/elementary/*.hurl >/dev/null 2>&1 || {
    echo "elementary test(s) failed" >&2
    echo "$HOST: 0 points"
    exit
}

SCORE=0
for test in $(find ./tests/graded -name '*.hurl' | sort); do
    parse_test_header "$(cat "$test" | head -n 1)";
    printf "running %s for %d point(s): " "$test" "$POINTS" >&2

    FAIL=1
    if [ "$TEST_TYPE" = "request" ]; then
        hurl -m 30 --test --variable "host=$HOST" "$test" >/dev/null 2>&1
        FAIL=$?
    elif [ "$TEST_TYPE" = "ffprobe" ]; then
        FFCHECK_PATH="${test%.hurl}.mjs"
        TEMP_PATH=$(mktemp)
    
        hurl -m 300 --variable "host=$HOST" "$test" -o "$TEMP_PATH"
        
        if [ "$?" = 0 ]; then
            node "$FFCHECK_PATH" "$TEMP_PATH"
            FAIL=$?
        else
            FAIL=1
        fi
        rm -f "$TEMP_PATH"
    fi

    [ "$FAIL" = 0 ] && {
        SCORE=$((SCORE + POINTS))
        echo 'pass' >&2
    } || echo fail >&2
done

echo "$HOST: $SCORE point(s)"