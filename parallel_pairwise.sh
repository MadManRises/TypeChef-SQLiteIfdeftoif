#!/bin/bash

th3IfdeftoifDir=/home/$USER/th3_generated_ifdeftoif
resultDir=~/sqlite
jobExportDir=$resultDir/pr_$1
if [ $USER == "rhein" ]; then
    th3IfdeftoifDir=/home/garbe/th3_generated_ifdeftoif
fi

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
    rm -rf tmppr_$1
    mkdir tmppr_$1
    cd tmppr_$1

    # find $1'th sub directory containing .test files, excluding stress folder
    TESTDIR=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)
    TESTDIRBASE=$(basename $TESTDIR)

    # find $2'th optionstruct
    IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1)
    IFCONFIGBASE=$(basename $IFCONFIG)

    # find $3'th .cfg
    TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" | sort | head -n $TH3CFGNO | tail -n 1)
    TH3CFGBASE=$(basename $TH3CFG)

    # count .test files
    TESTFILES=$(find $TESTDIR -name "*.test" | wc -l)

    cd ../TH3
    ./mkth3.tcl $TESTDIR/*.test "$TH3CFG" > ../tmppr_$1/th3_generated_test.c
    cd ../tmppr_$1

    #sed filters everything but the number of the configuration
    configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')

    # Copy files used for compilation into temporary directory
    cp $IFCONFIG id2i_optionstruct.h
    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h
    if cp $th3IfdeftoifDir/sqlite3_ifdeftoif_$TH3IFDEFNO.c sqlite3_ifdeftoif.c; then
        echo "pairwise testing: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE on $TESTFILES .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"

        # Compile normal sqlite
        originalGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
            -include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
            ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c 2>&1)
        # If gcc returns errors skip the testing
        if [ $? != 0 ]
        then
            echo -e "Variant can't be compiled for: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE with th3Config $TH3CFGBASE on $TESTFILES .test files in $TESTDIRBASE" > $jobExportDir/CompErrVar.txt
            echo -e "TH3 test can't compile original, skipping test; original GCC error:\n$originalGCC\n\n"
        else
            rm -rf $jobExportDir
            mkdir -p $jobExportDir
            # Run normal binary
            /usr/bin/time -f TH3execTime:sys:%S,usr:%U,real:%E,mem:%M -o $jobExportDir/time_variant.txt bash -c ./a.out &> chp_variant_$1.txt; expectedOutputValue=$?
            rm -f a.out

            # Compile ifdeftoif sqlite
            ifdeftoifGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
                sqlite3_ifdeftoif.c 2>&1)
            # If gcc returns errors don't start testing the ifdeftoif variant
            if [ $? != 0 ]
            then
                echo -e "Simulator can't be compiled for: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE with th3Config $TH3CFGBASE on $TESTFILES .test files in $TESTDIRBASE" > $jobExportDir/CompErrSim.txt
                echo -e "TH3 test can't compile ifdeftoif; expected: $expectedOutputValue\n; ifdeftoif GCC error:\n$ifdeftoifGCC\n\n"
            else
                # Run ifdeftoif binary
                /usr/bin/time -f TH3execTime:sys:%S,usr:%U,real:%E,mem:%M -o $jobExportDir/time_simulator.txt bash -c ./a.out &> chp_simulator_$1.txt; testOutputValue=$?
                python ../TypeChef-SQLiteIfdeftoif/experiment_evaluation/TH3LogCompare/log_compare.py chp_simulator_$1.txt chp_variant_$1.txt $jobExportDir
                if [ $testOutputValue -eq $expectedOutputValue ] ; then
                    echo -e "Test successful, exit Codes: $testOutputValue;\n\n"
                else 
                    if [ $expectedOutputValue -eq 0 ] ; then
                        echo -e "TH3 succeeds, ifdeftoif does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\n\n"
                    else
                        if [ $testOutputValue -eq 0 ] ; then
                            echo -e "Ifdeftoif succeeds, TH3 does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\n\n"
                        else
                            echo -e "TH3 test differs; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\n\n"
                        fi
                    fi 
                fi
                rm -f a.out
            fi
        fi
    fi
    cd ..
    rm -rf tmppr_$1
fi
