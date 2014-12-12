#!/bin/bash

#For this test, sqlite3_modified.c must include the shell.c
# #include "shell.c"

#./ifdeftoif_mod.sh
rm -f a.out
gcc sqlite3_ifdeftoif.c -w
rm -f mytestdb

echo "create table tbl1(one varchar(10), two smallint); insert into tbl1 values('goodbye', 20); select * from tbl1;" | ./a.out mytestdb 

rm -f mytestdb
rm -f a.out

