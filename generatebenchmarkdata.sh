#!/bin/bash

#How to run:
# "--privilged" is important on CentOS. Otherwise "su - hpcc" will fail with error
# "su: cannot open session: Permission denied"
#sudo docker run --privileged --rm -v "$PWD/test-platform.sh:/usr/local/bin/test.sh" hpccsystems/hpcc:<tag> test.sh


cd ~
mkdir -p tmp
cd tmp

# Start HPCC
#/etc/init.d/hpcc-init start > /dev/null 2>&1
#rc=$?
#if [ $rc -ne 0 ]; then
#  echo "Start HPCC failed Error code: $rc"
#  exit 1
#fi

#sleep 5

cat > testbenchmark.ecl << EOF
dataset_name7 := '~benchmark::integer::100mb';
unique_keys :=  100000;  // Should be less than number of records
unique_values := 10212; // Should be less than number of records

rec7 := {integer  key, integer  fill};
ds7 := DATASET(1250 * 50 * 100, transform(rec7, self.key := random() % unique_keys; self.fill := random() % unique_values;), DISTRIBUTED);

OUTPUT(ds7,,dataset_name7,overwrite);
EOF

cat  > verifybenchmark.ecl << EOF

rec := {integer  key, integer  fill};
sampledataset := DATASET('~benchmark::integer::100mb', rec, THOR);
output(count(sampledataset));
EOF

# Test ecl code through esp
/opt/HPCCSystems/bin/ecl run hthor testbenchmark.ecl > test_result 2>&1
rc=$?
if [ $rc -ne 0 ]; then
  echo "Generate sample data via ecl code through esp failed! Error code: $rc"
  exit 2
fi

# Validate result
/opt/HPCCSystems/bin/ecl run hthor verifybenchmark.ecl > test_result 2>&1
cat test_result | grep "<Row><Result_1>1558</Result_1></Row>" test_result > /dev/null
if [ $rc -ne 0 ]; then
  echo "Data validation failed - Expected: <Row><Result_1>1558</Result_1></Row>"
  exit 3
fi

echo "ECL generated sample data through esp succeeded!"
