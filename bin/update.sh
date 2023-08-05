#!/bin/sh
GRADER="$(dirname "$0")/grade.sh"
BASE_TABLE="./instances.csv"

setup_table() { # setup_table(path)
    echo 'points,hostname,commit,version' > "$1"
}

sort_table() { # sort_table(path)
    SORT_TMP=$(mktemp)
    head -n 1 "$1" > "$SORT_TMP"
    tail -n +2 "$1" | sort -nr >> "$SORT_TMP"
    mv "$SORT_TMP" "$1"
}

get_serverinfo() { # get_serverinfo(hostname)
    JSON=$(hurl --variable host="$1" tests/elementary/cors-enabled.hurl)
    COMMIT=$(echo "$JSON" | jq -r .commit)
    VERSION=$(echo "$JSON" | jq -r .version)

    URL=$(echo "$JSON" | jq -r .url)
    EXPECTED_URL="https://$1/"
    if [ "$URL" != "$EXPECTED_URL" ]; then
        echo "unexpected url: $URL != $EXPECTED_URL" >&2
        exit 1 # todo: handle load balanced instances (min(instance₀, instance₁, ..., instanceₙ) ?)
    fi

    if ! echo "$COMMIT" | grep -qE '^[0-9a-f]{0,7}$'; then
        echo "invalid commit short hash: $COMMIT" >&2
        exit 1
    fi

    if ! echo "$VERSION" | grep -qE '^([0-9]\.){0,4}[0-9]$'; then
        echo "invalid version: $VERSION" >&2
        exit 1
    fi
}

normalize_hostname() {
    # yoink: https://superuser.com/a/750442
    host "$HOSTNAME" >/dev/null 2>&1
    [ "$?" != 0 ] \
        && echo "invalid hostname: $HOSTNAME" && exit 1;
    HOSTNAME=$(echo "$HOSTNAME" | tr '[:upper:]' '[:lower:]')
}

do_rescore() { # do_rescore()
    TMPTAB=$(mktemp)
    setup_table "$TMPTAB"
    cat $BASE_TABLE \
    | tail -n +2 \
    | cut -d, -f2 \
    | while read hostname; do
        echo "running test suite on $hostname"
        do_insert "$hostname" "$TMPTAB"
    done

    sort_table "$TMPTAB"
    mv "$TMPTAB" $BASE_TABLE
}

do_insert() { # do_insert(hostname, path)
    HOSTNAME="$1"
    TABPATH="$2"

    [ ! -f "$TABPATH" ] \
      && setup_table "$TABPATH";

    normalize_hostname

    if grep "^[0-9]\+,$HOSTNAME" "$TABPATH"; then
        echo "$HOSTNAME already in table" >&2
        exit 1
    fi

    RESULT=$("$GRADER" "$1")

    POINTS=$(echo "$RESULT" | cut -d' ' -f2)
    get_serverinfo "$1"
    echo "$POINTS,$HOSTNAME,$COMMIT,$VERSION" >> "$TABPATH"
}


if [ "$1" = "rescore" ]; then
    do_rescore
elif [ "$1" = "insert" ]; then
    do_insert "$2" $BASE_TABLE
    sort_table $BASE_TABLE
else
    echo "usage: $0 update / $0 insert <hostname>" >&2
    exit 1
fi
