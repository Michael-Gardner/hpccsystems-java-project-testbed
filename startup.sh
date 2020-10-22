#!/bin/sh -l

#startup hpccsystems platform
/etc/init.d/hpcc-init start

git clone $1 hpcc4j
cd hpcc4j
mvn --batch-mode -Pbenchmark -Dmaven.test.skip=false \
    -Dmaven.gpg.skip=true clean install -e \
    -Dmaven.test.failure.ignore=false \
    -Dhpccconn=http://localhost:8010 \
    -Dwssqlport=8510 -Dmaven.javadoc.skip=true \
    --file pom.xml

results="$(cat dfsclient/results.json)"
echo "::set-output name=benchmark-results::$results"