#!/usr/bin/env bash

set -eu

mkdir -p reports

tests=0
fail=0
cases=""

check() {
    tests=$((tests + 1))

    if sh -c "$2" > /dev/null 2>&1; then
        cases="$cases<testcase classname='tpweek2' name='$1'/>"
    else
        fail=$((fail + 1))
        echo "ECHEC : $1"
        cases="$cases<testcase classname='tpweek2' name='$1'><failure message='echec'/></testcase>"
    fi
}

check "server.js existe" "test -f fichier-inexistant.js"
check "le serveur ecoute sur 3000" "grep -q 'listen(3000' server.js"
check "package.json contient express" "grep -q express package.json"

echo "<testsuite name='tpweek2' tests='$tests' failures='$fail'>$cases</testsuite>" > reports/results.xml

echo "$tests tests, $fail echec(s)"

test "$fail" -eq 0