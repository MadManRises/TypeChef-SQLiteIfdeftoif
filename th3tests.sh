#!/bin/bash
START_TIME=$SECONDS

echo "Starting featurewise tests."
./th3MultiConfigTest_featurewise.sh > th3_featurewise.txt 2>&1

echo "Starting pairwise tests."
./th3MultiConfigTest_pairwise.sh > th3_pairwise.txt 2>&1

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"