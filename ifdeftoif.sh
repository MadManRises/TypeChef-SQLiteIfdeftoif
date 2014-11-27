#!/bin/bash

# is sometimes generated by make or configure. TypeChef interprets it as presence condition file and breaks
rm sqlite3.pc

START_TIME=$SECONDS

ABSPATH=$(cd "$(dirname "$0")"; pwd)

# only one single file in sqlite amalgamation version
FNAME=sqlite3.c

cp sqlite3_original.c sqlite3.c

# set output files
outBase="$(dirname $FNAME)/$(basename $FNAME .c)"
outDbg="$outBase.dbg"
outPartialPreproc="$outBase.pi"
outErr="$outBase.err"
outTime="$outBase.time"


../Hercules/ifdeftoif.sh \
        --bdd --serializeAST --interface --debugInterface\
        -I /usr/local/include \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed \
        -I /usr/lib/gcc/x86_64-linux-gnu/4.8/include \
        -I /usr/include/x86_64-linux-gnu \
        -I /usr/include \
        --platfromHeader $ABSPATH/platform.h \
        --openFeat $ABSPATH/openfeatures.txt \
        --featureModelFExpr $ABSPATH/fm.txt \
        --typeSystemFeatureModelDimacs $ABSPATH/sqlite.dimacs \
        --featureModelFExpr ifdeftoif_helpers/custom_limitations.txt \
        --include $ABSPATH/partial_configuration.h \
        --parserstatistics \
        --writePI --ifdeftoifstatistics \
        -U WIN32 -U _WIN32 \
        --simpleSwitch \
	$FNAME \
	#-U NDEBUG \
	
	#option --featureModelDimacs must be before option --featureModelFExpr
	#undefined WIN32 and _WIN32 because i cannot compile/test them here anyway

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"

exit
