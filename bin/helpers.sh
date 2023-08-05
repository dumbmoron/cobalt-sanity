#!/bin/sh

nope() {
    echo "invalid test: $test; plz fix" >&2; exit 1
}

parse_test_header() {
    case "$1" in
        "# co: "*);;
        *) nope;
    esac

    CO_WORD="$(echo "$1" | cut -d' ' -f2)"
    [ "$CO_WORD" != "co:" ] && echo "CO_WORD is not co:" >&2 && nope;

    POINTS_WORD="$(echo "$1" | cut -d' ' -f5)";
    if [ "$POINTS_WORD" != "point" ] && [ "$POINTS_WORD" != "points" ]; then
        echo "POINTS_WORD is not point/s" >&2
        nope
    fi

    POINTS="$(echo "$1" | cut -d' ' -f4)";
    case "$POINTS" in
        ''|*[!0-9]*) echo "invalid number of points ($POINTS)" >&2; nope;;
        *);;
    esac

    TEST_TYPE="$(echo "$1" | cut -d' ' -f3 | sed 's/,$//')"
    if [ "$TEST_TYPE" != "ffprobe" ] && [ "$TEST_TYPE" != "request" ]; then
        echo "invalid test type: $TEST_TYPE" >&2
        nope
    fi
}