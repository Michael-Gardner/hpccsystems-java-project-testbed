#!/bin/sh -l

# startup hpccsystems platform
/etc/init.d/hpcc-init start

# generate ecl data needed for benchmark tests
/generatedata.sh

