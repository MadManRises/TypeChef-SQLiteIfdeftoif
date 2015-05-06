#!/bin/bash

TESTDIRS=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" | wc -l)
IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES * $IFCONFIGS))

TESTDIRNO=$(( ($1 / ($CFGFILES * $IFCONFIGS)) + 1 ))
TH3CFGNO=$(( (($1 / $IFCONFIGS) % $CFGFILES)  + 1 ))
IFCONFIGNO=$(( ($1 % $IFCONFIGS) + 1 ))

cd ..
mkdir tmp_$1
cd tmp_$1

# find $1'th sub directory containing .test files, excluding stress folder
TESTDIR=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)

# find $2'th optionstruct
IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1)

# find $3'th .cfg
TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" | sort | head -n $TH3CFGNO | tail -n 1)

echo "testing #ifConfig $IFCONFIG on .test files in $TESTDIR with th3Config $TH3CFG at $(date +"%T")"
cd ../TH3
./mkth3.tcl $TESTDIR/*.test "$TH3CFG" > ../tmp_$1/th3_generated_test.c
cd ../tmp_$1
cp th3_generated_test.c th3_generated_test_ifdeftoif.c
#insert /* Alex: added initialization of our version of the azCompileOpt array */ init_azCompileOpt();
sed -i \
    's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\/* Alex: added initialization of our version of the azCompileOpt array *\/ init_azCompileOpt()\;/' \
    th3_generated_test_ifdeftoif.c
#better never touch this sed again

#sed filters everything but the number of the configuration
configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')
echo "featurewise testing #ifConfig $IFCONFIG on .test files in $TESTDIR with th3Config $TH3CFG at $(date +"%T")"

# Copy files used for compilation into temporary directory
cp $IFCONFIG id2i_optionstruct.h
cp ../TypeChef-SQLiteIfdeftoif/sqlite3_ifdeftoif.c sqlite3_ifdeftoif.c
cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h

# Test normal sqlite
originalGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
    -include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/id2i_include_$configID.h" \
    ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c 2>&1)
# If gcc returns errors skip the testing
if [ $? != 0 ]
then
    echo -e "TH3 test can't compile original, skipping test; original GCC error:\n$originalGCC\n\n"
else
    expectedTestResult=$(bash -c '(./a.out); exit $?' 2>&1)
    expectedOutputValue=$?
    rm -f a.out

    # Test ifdeftoif sqlite
    cp $IFCONFIG ../ifdeftoif/id2i_optionstruct.h
    ifdeftoifGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        ../TypeChef-SQLiteIfdeftoif/sqlite3_ifdeftoif.c th3_generated_test_ifdeftoif.c 2>&1)
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