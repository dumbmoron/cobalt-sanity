#!/bin/sh

. $(dirname "$0")/helpers.sh

get_max() {
    MAX_PTS=0
    for test in $(find ./tests/graded -name '*.hurl'); do
        header=$(head -n 1 "$test")
        parse_test_header "$header"
        MAX_PTS=$((MAX_PTS + POINTS))
    done
}

get_max
echo "Maximum possible points: $MAX_PTS"

echo '| hostname | points | version | commit |'
echo '| -------- | ------ | ------- | ------ |'
tail -n +2 ./instances.csv | while read instance; do
    POINTS=$(echo "$instance" | cut -d, -f1)
    HOSTNAME=$(echo "$instance" | cut -d, -f2)
    COMMIT=$(echo "$instance" | cut -d, -f3)
    VERSION=$(echo "$instance" | cut -d, -f4)
    echo "| [$HOSTNAME](https://$HOSTNAME/api/serverInfo) | $POINTS | $VERSION | [$COMMIT](https://github.com/wukko/cobalt/commit/$COMMIT) |"
done
