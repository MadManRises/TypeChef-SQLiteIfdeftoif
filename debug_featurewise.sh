#!/bin/bash

th3IfdeftoifDir=/home/$USER/th3_generated_ifdeftoif
resultDir=~/sqlite
jobExportDir=$resultDir/ft_$1
if [ $USER == "rhein" ]; then
    th3IfdeftoifDir=/home/garbe/th3_generated_ifdeftoif
fi

TESTDIRS=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg" | wc -l)
IFCONFIGS=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | wc -l)
TOTAL=$(( $TESTDIRS * $CFGFILES * $IFCONFIGS))

TESTDIRNO=$(( ($1 / ($CFGFILES * $IFCONFIGS)) + 1 ))
TH3CFGNO=$(( (($1 / $IFCONFIGS) % $CFGFILES)  + 1 ))
IFCONFIGNO=$(( ($1 % $IFCONFIGS) + 1 ))
TH3IFDEFNO=$(( $1 / $IFCONFIGS ))

if [ $1 -lt $TOTAL ]; then
    cd ..
    rm -rf debugft_$1
    mkdir debugft_$1
    cd debugft_$1

    # find $1'th sub directory containing .test files, excluding stress folder
    TESTDIR=$(find ../TH3 -name '*test' ! -path "./TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1)
    TESTDIRBASE=$(basename $TESTDIR)

    # find $2'th optionstruct
    IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1)
    IFCONFIGBASE=$(basename $IFCONFIG)

    # find $3'th .cfg
    TH3CFG=$(find ../TH3/cfg/ -name "*.cfg" | sort | head -n $TH3CFGNO | tail -n 1)
    TH3CFGBASE=$(basename $TH3CFG)

    # count .test files
    TESTFILES=$(find $TESTDIR -name "*.test" | wc -l)

    cd ../TH3
    ./mkth3.tcl $TESTDIR/*.test "$TH3CFG" > ../debugft_$1/th3_generated_test.c
    cd ../debugft_$1

    #sed filters everything but the number of the configuration
    configID=$(basename $IFCONFIG | sed 's/id2i_optionstruct_//' | sed 's/.h//')

    # Copy files used for compilation into temporary directory
    cp $IFCONFIG id2i_optionstruct.h
    cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h
    cp ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/id2i_include_$configID.h id2i_include.h
    cp ../TypeChef-SQLiteIfdeftoif/partial_configuration.h .
    cp ../TypeChef-SQLiteIfdeftoif/sqlite3_original.c .
    if cp $th3IfdeftoifDir/sqlite3_ifdeftoif_$TH3IFDEFNO.c sqlite3_ifdeftoif.c; then
        echo "featurewise debugging: jobid $1 ifdeftoif $TH3IFDEFNO; #ifConfig $IFCONFIGBASE on $TESTFILES .test files in $TESTDIRBASE with th3Config $TH3CFGBASE at $(date +"%T")"
    else
        echo "could not find sqlite3_ifdeftoif_$TH3IFDEFNO.c"
    fi
    cd ..
fi