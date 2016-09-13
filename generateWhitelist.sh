whitelistDir=./th3_whitelist
TH3Dir=/home/$USER/TypeChef/TH3
resultDir=/home/$USER/perf_results_chimaira
TESTDIRS=$(find $TH3Dir -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find $TH3Dir/cfg/ -name "*.cfg" ! -name "cG.cfg" | wc -l)

mkdir -p $whitelistDir

cd $resultDir
OLDDIR=""
for dir in `seq 0 299`; do
    cd $dir
    list=()
    prefix="./"
    TESTDIRNO=$(( ($dir / $CFGFILES) + 1 ))
    TESTDIR=$(find $TH3Dir -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1 | xargs basename)
    #Prefix example './bugs/'
    completePrefix="$prefix$TESTDIR/"
    suffix=".test"

    while read -r line
    do 
        configno=$(ls perf_*.txt | wc -l)
        testno=$(grep "^$line" perf_*.txt | wc -l)
        # check if a 'Begin $TESTNAME' is present in every file
        if [ $testno -eq $configno ]; then list+=( $(cut -d "." -f 2 <<< $line | sed -e "s/bug_//" | sed -e "s/req1_//" | sed -e "s/extra1_//" | sed -e "s/extra_//" | sed -e "s/e1_//" | sed -e "s/no_journal_opt/no_journal_opt_01/") ); fi
    done < <(grep -h "^Begin " perf_*.txt)

    new=$(echo ${list[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
    res="Whitelist=("
    prefix=""
    for var in $new; do
        if [ $TESTDIR = bugs ]; then var=$(echo $var | tr '_' '-') ; fi
        if [ $TESTDIR = extra1 ] && [ $var = "pager01" ]; then var="epager01"; fi
        if [ $TESTDIR = dev ] && [ $var = "where09dev" ]; then var="where09"; fi
        res=$res$prefix
        prefix=" "
        TESTFILE=$var$suffix
        FULLTESTFILEPATH=$TH3Dir/$TESTDIR/$TESTFILE
        if [ -f $FULLTESTFILEPATH ]; then
            res="$res\"${completePrefix}$var$suffix\""
        else
         echo "Can't find $FULLTESTFILEPATH"
        fi
        
    done
    res="$res)"
    echo $res > $whitelistDir/$dir.txt
    if [ ! $OLDDIR = "" ] && [ ! $OLDDIR = $TESTDIR ]; then echo "$TESTDIR done"; fi
    cd ..
    OLDDIR=$TESTDIR
done