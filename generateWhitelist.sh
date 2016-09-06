whitelistDir=/home/$USER/whitelist
TH3Dir=/home/$USER/TypeChef/TH3
resultDir=/home/$USER/perf_results_chimaira
TESTDIRS=$(find $TH3Dir -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find $TH3Dir/cfg/ -name "*.cfg" ! -name "cG.cfg" | wc -l)

mkdir -p $whitelistDir

cd $resultDir

for dir in `seq 0 299`; do
    cd $dir
    list=()
    prefix="./"
    TESTDIRNO=$(( ($dir / $CFGFILES) + 1 ))
    TESTDIR=$(find $TH3Dir -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1 | xargs basename)
    completePrefix="$prefix$TESTDIR/"

    while read -r line
    do 
        configno=$(ls perf_*.txt | wc -l)
        testno=$(grep "^$line" perf_*.txt | wc -l)
        if [ $testno -eq $configno ]; then list+=( $(cut -d "." -f 2 <<< $line) ); fi
    done < <(grep -h "^Begin " perf_*.txt)

    new=$(echo ${list[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
    res="Whitelist=("
    prefix=""
    for var in $new; do
        res=$res$prefix
        prefix=" "
        res="$res\"${completePrefix}$var\""
    done
    res="$res)"
    echo $res > $whitelistDir/$dir.txt
    cd ..
done