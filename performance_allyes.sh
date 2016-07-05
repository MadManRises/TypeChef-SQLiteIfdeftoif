#!/bin/bash

th3IfdeftoifDir=/home/$USER/th3_generated_performance
resultDirectory=$th3IfdeftoifDir/../performance_results
resultDir=$resultDirectory/allyes
if [ $USER == "rhein" ]; then
    th3IfdeftoifDir=/home/garbe/th3_generated_performance
fi

if [ ! -d $resultDirectory ]; then
    mkdir -p $resultDirectory
fi

TESTDIRS=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" ! -name "cG.cfg" | wc -l)
#IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/featurewise/generated/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES ))

TESTDIRNO=$(( ($1 / $CFGFILES) + 1 ))
TH3CFGNO=$(( ($1 % $CFGFILES)  + 1 ))
TH3IFDEFNO=$1

if [ $1 -lt $TOTAL ]; then
    cd ..
    tmpDir=tmp_ay_$1
    rm -rf $tmpDir
    rm -rf $resultDir/perf_ay_$1.txt
    rm -rf $resultDir/var_ay_$1.txt
    rm -rf $resultDir/sim_ay_$1.txt

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

    ./mkth3.tcl $TESTFILES "$TH3CFG" > ../$tmpDir/th3_generated_test.c
    cd ../$tmpDir

    # insert performance function at the start and end of the main function
    sed -i '1s/^/#include "\.\.\/Hercules\/performance\/noincludes.c"\n#include "\.\.\/Hercules\/performance\/perf_measuring\.c"\n/' th3_generated_test.c
    sed -i 's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\n  id2iperf_time_start()\;/' th3_generated_test.c
    sed -i 's/return nFail\;/id2iperf_time_end()\;\n  return nFail\;/' th3_generated_test.c

    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h


    # Test allyes variant
    echo "performance testing allyes variant: jobid $1 ifdeftoif $TH3IFDEFNO on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
    originalGCC=$(bash -c 'gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
        -I /usr/local/include \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include \
        -I /usr/include/x86_64-linux-gnu \
        -I /usr/include \
        -include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/performance/allyes_include.h" \
        -include "../TypeChef-SQLiteIfdeftoif/partial_configuration.h" \
        -include "../TypeChef-SQLiteIfdeftoif/sqlite3_defines.h" \
        ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c; exit $?' 2>&1)
    originalGCCexit=$?

    if [ $originalGCCexit != 0 ]
    then
        echo -e "can not compile allyes variant"
    else
        # Run normal binary
        ./a.out > $resultDir/var_ay_$1.txt
        # Clear temporary variant files
        rm -rf *.out
        rm -rf *.db
        rm -rf *.lock
    fi

    # Test allyes performance simulation
    config=../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/performance/allyes_optionstruct.h
    cp $config id2i_optionstruct.h
    if cp $th3IfdeftoifDir/sqlite3_performance_$TH3IFDEFNO.c sqlite3_performance.c; then
        echo "performance testing allyes performance: jobid $1 ifdeftoif $TH3IFDEFNO on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"

        performanceGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 sqlite3_performance.c 2>&1)
        # gcc returns errors
        if [ $? != 0 ]; then
            echo "can not compile allyes performance"
            echo -e $performanceGCC
            exit
        else
            # Run ifdeftoif binary
            # echo -e "\n\n-= Hercules Performance =-\n"
            ./a.out > $resultDir/perf_ay_$1.txt 2>&1
            # delete files where the performance prediction has stack inconsistencies
            if ! grep -q "Remaining stack size: 0" $resultDir/perf_ay_$1.txt; then
                # rm -rf $resultDir/perf_ft_$configID.txt
                echo -e "Stack inconsistencies for config $configID"
            fi
            # Clear temporary simulator files
            rm -rf *.db
            rm -rf *.out
            rm -rf *.lock
        fi
    fi

    # Test allyes performance simulator
    config=../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/performance/allyes_optionstruct.h
    cp $config id2i_optionstruct.h
    if cp $th3IfdeftoifDir/sqlite3_performance_$TH3IFDEFNO.c sqlite3_simulator.c; then
        echo "performance testing allyes simulator: jobid $1 ifdeftoif $TH3IFDEFNO on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
        # replace include directive to perf_nomeasuring.c
        sed -i '0,/perf_measuring.c/ s//perf_nomeasuring.c/' sqlite3_simulator.c
        performanceGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 sqlite3_simulator.c 2>&1)
        # gcc returns errors
        if [ $? != 0 ]; then
            echo "can not compile allyes simulator"
            echo -e $performanceGCC
            exit
        else
            # Run ifdeftoif binary
            # echo -e "\n\n-= Hercules Performance =-\n"
            ./a.out > $resultDir/perf_sim_$1.txt 2>&1
            # delete files where the performance prediction has stack inconsistencies
            if ! grep -q "Remaining stack size: 0" $resultDir/sim_ay_$1.txt; then
                # rm -rf $resultDir/perf_ft_$configID.txt
                echo -e "Stack inconsistencies for config $configID"
            fi
            # Clear temporary simulator files
            rm -rf *.db
            rm -rf *.out
            rm -rf *.lock
        fi
    fi

    cd ..
    #rm -rf $tmpDir
fi
