#!/bin/bash

th3IfdeftoifDir=/home/$USER/th3_generated_performance
resultDirectory=$th3IfdeftoifDir/../performance_results
resultDir=$resultDirectory/$1
if [ $USER == "rhein" ]; then
    th3IfdeftoifDir=/home/garbe/th3_generated_performance
fi

if [ ! -d $resultDirectory ]; then
    mkdir -p $resultDirectory
fi

TESTDIRS=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" ! -name "cG.cfg" | wc -l)
#IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES ))

TESTDIRNO=$(( ($1 / $CFGFILES) + 1 ))
TH3CFGNO=$(( ($1 % $CFGFILES)  + 1 ))
TH3IFDEFNO=$1

if [ $1 -lt $TOTAL ]; then
    cd ..
    tmpDir=tmp_var_pr_$1
    rm -rf $tmpDir
    rm -rf $resultDir/var_pr_*.txt
    rm -rf $resultDir/sim_pr_*.txt

    mkdir $tmpDir
    mkdir -p $resultDir
    cd $tmpDir

    # find $1'th sub directory containing .test files, excluding stress folder
    TESTDIR=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)
    TESTDIRBASE=$(basename $TESTDIR)

    # find $3'th .cfg
    TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" ! -name "cG.cfg" | sort | head -n $TH3CFGNO | tail -n 1)
    TH3CFGBASE=$(basename $TH3CFG)

    # count .test files
    TESTFILENO=$(find $TESTDIR -name "*.test" | wc -l)

    cd ../TH3
    # Ignore ctime03.test since it features a very large struct loaded with 100 different #ifdefs & #elses
    # Ignore date2.test since it returns the systems local time; this makes string differences in test results impossible
    TESTFILES=$(find $TESTDIR -name "*.test" ! -name "ctime03.test" ! -name "date2.test" | sort)
    echo "performance prediction: $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
    # Use whitelist for tests if it exists
    if [ -f ../TypeChef-SQLiteIfdeftoif/th3_whitelist/$1.txt ]; then
        source ../TypeChef-SQLiteIfdeftoif/th3_whitelist/$1.txt
        TESTFILES=$Whitelist
    fi

    ./mkth3.tcl $TESTFILES "$TH3CFG" > ../$tmpDir/th3_generated_test.c
    cd ../$tmpDir

    #insert performance function at the start and end of the main function
    sed -i '1s/^/#include "\.\.\/Hercules\/performance\/noincludes.c"\n#include "\.\.\/Hercules\/performance\/perf_measuring\.c"\n/' th3_generated_test.c
    sed -i 's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\n  id2iperf_time_start()\;/' th3_generated_test.c
    sed -i 's/return nFail\;/id2iperf_time_end()\;\n  return nFail\;/' th3_generated_test.c

    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h

    # test pairwise config variant
    for config in ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/Prod*.h; do
        # find $2'th optionstruct
        IFCONFIG=$config
        IFCONFIGBASE=$(basename $IFCONFIG)

        #sed filters everything but the number of the configuration
        configID=$(basename $IFCONFIG | sed 's/Prod//' | sed 's/.h//')

        # Copy files used for compilation into temporary directory
        cp $IFCONFIG id2i_optionstruct.h

        echo "performance testing variant: jobid $1; #ifConfig $IFCONFIGBASE on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
        originalGCC=$(bash -c 'gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -I /usr/local/include \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include \
        -I /usr/include/x86_64-linux-gnu \
        -I /usr/include \
        -include $0 \
        -include "../TypeChef-SQLiteIfdeftoif/partial_configuration.h" \
        -include "../TypeChef-SQLiteIfdeftoif/sqlite3_defines.h" \
        ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c; exit $?' $config 2>&1)
        originalGCCexit=$?

        if [ $originalGCCexit != 0 ]
        then
            echo -e $originalGCC
            echo -e "\n\ncan not compile original gcc file"
            exit
        else
            # Run normal binary
            ./a.out > $resultDir/var_pr_$configID.txt 2>&1

            # Clear temporary test files
            rm -rf *.out
            rm -rf *.db
            rm -rf *.lock
        fi
    done

    # test allyes performance simulation without time measurements
    for config in ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/id2i_optionstruct_*.h; do
        # find $2'th optionstruct
        IFCONFIG=$config
        IFCONFIGBASE=$(basename $IFCONFIG)

        #sed filters everything but the number of the configuration
        configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')

        # Copy files used for compilation into temporary directory
        cp $IFCONFIG id2i_optionstruct.h

        if cp $th3IfdeftoifDir/sqlite3_performance_$TH3IFDEFNO.c sqlite3_simulator.c; then
            echo "performance testing simulator: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
            # replace include directive to perf_nomeasuring.c
            sed -i '0,/perf_measuring.c/ s//perf_nomeasuring.c/' sqlite3_simulator.c
            performanceGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 sqlite3_simulator.c 2>&1)
            # gcc returns errors
            if [ $? != 0 ]; then
                echo "can not compile performance file"
                echo -e $performanceGCC
                exit
            else
                # Run ifdeftoif binary
                # echo -e "\n\n-= Hercules Performance =-\n"
                ./a.out > $resultDir/sim_pr_$configID.txt 2>&1
                # delete files where the performance prediction has stack inconsistencies
                if ! grep -q "Remaining stack size: 0" $resultDir/sim_pr_$configID.txt; then
                    # rm -rf $resultDir/perf_pr_$configID.txt
                    echo -e "Stack inconsistencies for config $configID"
                fi
                # Clear temporary simulator files
                rm -rf *.db
                rm -rf *.out
                rm -rf *.lock
            fi
        fi
    done

    cd ..
    rm -rf $tmpDir
fi
