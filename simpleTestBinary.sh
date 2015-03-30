#!/bin/bash

./ifdeftoif_mod.sh
rm -f a.out
gcc shell.c sqlite3_ifdeftoif.c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -w
rm -f mytestdb

result=$(echo "create table tbl1(one varchar(10), two smallint); insert into tbl1 values('goodbye', 20); select * from tbl1;" | ./a.out mytestdb)
if [ "$result" == "goodbye|20" ]; then
    echo "Test successful"
else
    echo "Test failed, expected 'goodbye|20' but got $result"
fi

rm -f mytestdb
rm -f a.out

exit