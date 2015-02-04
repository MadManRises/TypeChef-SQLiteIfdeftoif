#!/bin/bash
START_TIME=$SECONDS

./th3MultiConfigTest_featurewise.sh > th3_featurewise.txt 2>&1

./th3MultiConfigTest_pairwise.sh > th3_pairwise.txt 2>&1

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"