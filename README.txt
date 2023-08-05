cobalt-sanity

deps: hurl(1), jq(1), tr(1), sort(1), host(1), mktemp(1), node(1)
sanity tests for checking a cobalt instance's ability to serve requests
note that i am not satisfied with this
output in `instances.csv`, `instances.json`, `leaderboard.md`

initial:
    bin/update.sh insert <instance_0>
    bin/update.sh insert <instance_1>
    ...
    bin/update.sh insert <instance_n>
    bin/mktab.sh > leaderboard.md
    bin/mkjson.mjs > instances.json

periodic:
    bin/update.sh rescore
    bin/mktab.sh > leaderboard.md
    bin/mkjson.mjs > instances.json
