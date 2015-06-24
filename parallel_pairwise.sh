#!/bin/bash

th3IfdeftoifDir=/home/garbe/th3_generated_ifdeftoif

TESTDIRS=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" | wc -l)
IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES * $IFCONFIGS))

TESTDIRNO=$(( ($1 / ($CFGFILES * $IFCONFIGS)) + 1 ))
TH3CFGNO=$(( (($1 / $IFCONFIGS) % $CFGFILES)  + 1 ))
IFCONFIGNO=$(( ($1 % $IFCONFIGS) + 1 ))
TH3IFDEFNO=$(( $1 / $IFCONFIGS ))

if [ $1 -lt $TOTAL ]; then
    cd ..
    mkdir tmp_$1
    cd tmp_$1

    # find $1'th sub directory containing .test files, excluding stress folder
    TESTDIR=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)

    # find $2'th optionstruct
    IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1)

    # find $3'th .cfg
    TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" | sort | head -n $TH3CFGNO | tail -n 1)

    cd ../TH3
    ./mkth3.tcl $TESTDIR/*.test "$TH3CFG" > ../tmp_$1/th3_generated_test.c
    cd ../tmp_$1

    #sed filters everything but the number of the configuration
    configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')
    echo "pairwise testing: jobid $1 #ifConfig $IFCONFIG on .test files in $TESTDIR with th3Config $TH3CFG at $(date +"%T")"

    # Copy files used for compilation into temporary directory
    cp $IFCONFIG id2i_optionstruct.h
    cp $th3IfdeftoifDir/sqlite3_ifdeftoif_$TH3IFDEFNO.c sqlite3_ifdeftoif.c
    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h

    # Test normal sqlite
    originalGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
        ../TypeChef-SQLiteIfdeftoif/sqlite3_original_fixed.c th3_generated_test.c 2>&1)
    # If gcc returns errors skip the testing
    if [ $? != 0 ]
    then
        echo -e "TH3 test can't compile original, skipping test; original GCC error:\n$originalGCC\n\n"
    else
        expectedTestResult=$(bash -c '(./a.out); exit $?' 2>&1)
        expectedOutputValue=$?
        rm -f a.out

        # Test ifdeftoif sqlite
        ifdeftoifGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
            sqlite3_ifdeftoif.c 2>&1)
        # If gcc returns errors don't start testing the ifdeftoif variant
        if [ $? != 0 ]
        then
            echo -e "TH3 test can't compile ifdeftoif; expected: $expectedOutputValue\nExpected test output:"
            echo -e "$expectedTestResult" | tail -n 10
            echo -e "\nIfdeftoif GCC error:"
            echo -e "$ifdeftoifGCC"
            echo -e "\n"
        else
            ifdeftoifTestResult=$(bash -c '(./a.out); exit $?' 2>&1)
            testOutputValue=$?
            if [ $testOutputValue -eq $expectedOutputValue ] ; then
                echo -e "Test successful, exit Codes: $testOutputValue;\n\n"
            else 
                if [ $expectedOutputValue -eq 0 ] ; then
                    echo -e "TH3 succeeds, ifdeftoif does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nIfdeftoif test output:"
                    echo -e "$ifdeftoifTestResult" | tail -n 10
                    echo -e "\n"
                else
                    if [ $testOutputValue -eq 0 ] ; then
                        echo -e "Ifdeftoif succeeds, TH3 does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nExpected test output:"
                        echo -e "$expectedTestResult" | tail -n 10
                        echo -e "\n"
                    else
                        echo -e "TH3 test differs; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nExpected test output:"
                        echo -e "$expectedTestResult" | tail -n 10
                        echo -e "\nIfdeftoif test output:"
                        echo -e "$ifdeftoifTestResult" | tail -n 10
                        echo -e "\n"
                    fi
                fi 
            fi
            rm -f a.out
        fi
    fi

    cd ..
    rm -rf tmp_$1
fi
