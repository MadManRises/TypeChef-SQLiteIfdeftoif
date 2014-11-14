#!/bin/bash
START_TIME=$SECONDS

ABSPATH=$(cd "$(dirname "$0")"; pwd)
#gcc shell.c sqlite3_ifdeftoif.c -lpthread -ldl > sqlite3_result.txt 2>&1

# shell.c is now included by sqlite3.c
# -o out.o means that the produced executable is saved in out.o
# can be tested with ./out.o
gcc sqlite3_ifdeftoif.c -lpthread -ldl -o out.o > sqlite3_result.txt 2>&1

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
exit
