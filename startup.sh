#!/bin/sh -l

#startup hpccsystems platform
/etc/init.d/hpcc-init start

# generate ecl data needed for benchmark tests
/generatedata.sh

result_file="${INPUT_RESULTFILE}"
#printenv
git clone --branch ${GITHUB_REF##[a-zA-Z0-9]*\/} ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY} clone-repo
cd clone-repo
mvn --batch-mode -Pbenchmark -Dmaven.test.skip=false \
    -Dmaven.gpg.skip=true clean install -e \
    -Dmaven.test.failure.ignore=false \
    -Dhpccconn=http://localhost:8010 \
    -Dwssqlport=8510 -Dmaven.javadoc.skip=true \
    --file pom.xml

results="$(cat dfsclient/results.json)"
echo "::set-output name=benchmarkResults::$results"
