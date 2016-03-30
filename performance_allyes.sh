#!/bin/bash

th3IfdeftoifDir=/home/$USER/th3_generated_performance
resultDir=~/sqlite
jobExportDir=$resultDir/pf_$1
if [ $USER == "rhein" ]; then
    th3IfdeftoifDir=/home/garbe/th3_generated_performance
fi

TESTDIRS=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" ! -name "cG.cfg" | wc -l)
#IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES ))

TESTDIRNO=$(( ($1 / $CFGFILES) + 1 ))
TH3CFGNO=$(( ($1 % $CFGFILES)  + 1 ))
TH3IFDEFNO=$1

if [ $1 -lt $TOTAL ]; then
    cd ..
    rm -rf tmppf_$1
    mkdir tmppf_$1
    cd tmppf_$1

    # find $1'th sub directory containing .test files, excluding stress folder
    TESTDIR=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)
    TESTDIRBASE=$(basename $TESTDIR)

    # find $2'th optionstruct
    IFCONFIG=../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/performance/allyes_optionstruct.h
    IFCONFIGBASE=$(basename $IFCONFIG)

    # find $3'th .cfg
    TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" ! -name "cG.cfg" | sort | head -n $TH3CFGNO | tail -n 1)
    TH3CFGBASE=$(basename $TH3CFG)

    # count .test files
    TESTFILENO=$(find $TESTDIR -name "*.test" | wc -l)

    cd ../TH3
    # Ignore ctime03.test since it features a very large struct loaded with 100 different #ifdefs & #elses
    # Ignore date2.test since it returns the systems local time; this makes string differences in test results impossible
    TESTFILES=$(find $TESTDIR -name "*.test" ! -name "ctime03.test" ! -name "date2.test" | sort)
    ./mkth3.tcl $TESTFILES "$TH3CFG" > ../tmppf_$1/th3_generated_test.c
    cd ../tmppf_$1

    #sed filters everything but the number of the configuration
    configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')

    # Copy files used for compilation into temporary directory
    cp $IFCONFIG id2i_optionstruct.h
    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h

    if ! cp $th3IfdeftoifDir/sqlite3_performance_$TH3IFDEFNO.c sqlite3_performance.c &> /dev/null ; then
        ./../TypeChef-SQLiteIfdeftoif/parallel_th3_test_performance.sh $1
    fi
    if cp $th3IfdeftoifDir/sqlite3_performance_$TH3IFDEFNO.c sqlite3_performance.c; then
        echo "performance testing: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE on $TESTFILENO .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"

        # Compile normal sqlite
        originalGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
            -I /usr/local/include \
            -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed \
            -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include \
            -I /usr/include/x86_64-linux-gnu \
            -I /usr/include \
            -include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/performance/allyes_include.h" \
            -include "../TypeChef-SQLiteIfdeftoif/partial_configuration.h" \
            -include "../TypeChef-SQLiteIfdeftoif/sqlite3_defines.h" \
            ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c 2>&1)

        if [ $? != 0 ]
            then
                echo -e $originalGCC
                echo -e "\n\ncan not compile original gcc file"
            else
                # Run normal binary
                echo -e "-= Original Binary =-\n"
                ./a.out
                # Clear temporary variant files
                rm -rf *.out
                rm -rf *.db
                rm -rf *.lock

                performanceGCC=$(gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 sqlite3_performance.c 2>&1)
                # gcc returns errors
                if [ $? != 0 ]; then
                    echo "can not compile performance file"
                else
                    # Run ifdeftoif binary
                    echo -e "\n\n-= Hercules Performance =-\n"
                    ./a.out
                fi
        fi
        # Clear temporary simulator files
        rm -rf *.db
        rm -rf *.out
        rm -rf *.lock
    fi
    cd ..
    #rm -rf tmppf_$1
fi
