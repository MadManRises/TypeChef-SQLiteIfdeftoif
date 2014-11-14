#!/bin/bash
START_TIME=$SECONDS

ABSPATH=$(cd "$(dirname "$0")"; pwd)
gcc shell.c sqlite3_ifdeftoif.c -lpthread -ldl > sqlite3_result.txt 2>&1
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
exit
