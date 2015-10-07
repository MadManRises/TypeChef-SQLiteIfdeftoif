sqliteResultDir=/home/garbe/sqlite
if [ $USER == "flo" ]; then
    sqliteResultDir=/home/flo/sqlite
fi

cd ..

FeaturewiseDirectories=$(find $sqliteResultDir -type d -name "ft_*" | wc -l)
PairwiseDirectories=$(find $sqliteResultDir -type d -name "pr_*" | wc -l)

TESTDIRS=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | wc -l)
CFGFILES=$(find ../TH3/cfg/ -name "*.cfg"  ! -name "cG.cfg" | wc -l)
IFCONFIGSFT=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | wc -l)
IFCONFIGSPR=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | wc -l)

Header=JobId,IfdefJobId,SimExitCode,VarExitCode,DiffErrors,ErrOnlyInSim,ErrOnlyInVar,OkInBoth,SameErrors,TestOnlyInSim,TestOnlyInVar,VarTime,SimTime,TestDir,TestCfg,ProgramCfg
# featurewise
rm -rf $sqliteResultDir/featurewise.csv
if [ $FeaturewiseDirectories -gt 0 ]; then
    echo $Header >> $sqliteResultDir/featurewise.csv
    for dir in $sqliteResultDir/ft_*/
    do
        JobId=$(basename $dir | sed 's/ft_//')
        TESTDIRNO=$(( ($JobId / ($CFGFILES * $IFCONFIGSFT)) + 1 )); TESTDIR=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1); TESTDIRBASE=$(basename $TESTDIR)
        TH3CFGNO=$(( (($JobId / $IFCONFIGSFT) % $CFGFILES)  + 1 )); TH3CFG=$(find ../TH3/cfg/ -name "*.cfg"  ! -name "cG.cfg" | sort | head -n $TH3CFGNO | tail -n 1); TH3CFGBASE=$(basename $TH3CFG)
        IFCONFIGNO=$(( ($JobId % $IFCONFIGSFT) + 1 )); IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/feature-wise/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1); IFCONFIGBASE=$(basename $IFCONFIG)
        TH3IFDEFNO=$(( $JobId / $IFCONFIGSFT ))

        SimExitCode=666; if [ -a $dir/ExitCodes.txt ]; then SimExitCode=$(sed -nr 's/Sim: ([0-9]+)/\1/p' $dir/ExitCodes.txt); fi
        VarExitCode=666; if [ -a $dir/ExitCodes.txt ]; then VarExitCode=$(sed -nr 's/Var: ([0-9]+)/\1/p' $dir/ExitCodes.txt); fi
        DiffErrors=0; if [ -a $dir/DiffErrors.txt ]; then DiffErrors=$(grep -P "^[^\s]" $dir/DiffErrors.txt | wc -l); fi
        ErrOnlyInSim=0; if [ -a $dir/ErrOnlyInSim.txt ]; then ErrOnlyInSim=$(grep -P "^[^\s]" $dir/ErrOnlyInSim.txt | wc -l); fi
        ErrOnlyInVar=0; if [ -a $dir/ErrOnlyInVar.txt ]; then ErrOnlyInVar=$(grep -P "^[^\s]" $dir/ErrOnlyInVar.txt | wc -l); fi
        OkInBoth=0; if [ -a $dir/OkInBoth.txt ]; then OkInBoth=$(grep -P "^[^\s]" $dir/OkInBoth.txt | wc -l); fi
        SameErrors=0; if [ -a $dir/SameErrors.txt ]; then SameErrors=$(grep -P "^[^\s]" $dir/SameErrors.txt | wc -l); fi
        TestOnlyInSim=0; if [ -a $dir/TestOnlyInSim.txt ]; then TestOnlyInSim=$(grep -P "^[^\s]" $dir/TestOnlyInSim.txt | wc -l); fi
        TestOnlyInVar=0; if [ -a $dir/TestOnlyInVar.txt ]; then TestOnlyInVar=$(grep -P "^[^\s]" $dir/TestOnlyInVar.txt | wc -l); fi
        SimTime=$(sed -nr 's/.*real:([0-9]?[0-9]:[0-9][0-9]:[0-9][0-9]|[0-9]?[0-9]:[0-9][0-9]\.[0-9][0-9]).*/\1/p' $dir/time_simulator.txt)
        VarTime=$(sed -nr 's/.*real:([0-9]?[0-9]:[0-9][0-9]:[0-9][0-9]|[0-9]?[0-9]:[0-9][0-9]\.[0-9][0-9]).*/\1/p' $dir/time_variant.txt)
        SimHours=0; VarHours=0; SimMin=0; VarMin=0; SimSec=0; VarSec=0; SimHSec=".00"; VarHSec=".00"
        if [[ $SimTime == *"."* ]]; then
            SimMin=$(echo $SimTime | sed -r 's/([0-9]?[0-9]):[0-9][0-9]\.[0-9][0-9]/\1/')
            SimSec=$(echo $SimTime | sed -r 's/[0-9]?[0-9]:([0-9][0-9])\.[0-9][0-9]/\1/')
            SimHSec=$(echo $SimTime | sed -r 's/[0-9]?[0-9]:[0-9][0-9](\.[0-9][0-9])/\1/')
        else
            SimHours=$(echo $SimTime | sed -r 's/([0-9]?[0-9]):[0-9][0-9]:[0-9][0-9]/\1/')
            SimMin=$(echo $SimTime | sed -r 's/[0-9]?[0-9]:([0-9][0-9]):[0-9][0-9]/\1/')
            SimSec=$(echo $SimTime | sed -r 's/[0-9]?[0-9]:[0-9][0-9]:([0-9][0-9])/\1/')
        fi
        SimTimeSecOnly=$(( 3600*$SimHours + 60*$SimMin + $SimSec ))
        SimTime=$SimTimeSecOnly$SimHSec
        if [[ $VarTime == *"."* ]]; then
            VarMin=$(echo $VarTime | sed -r 's/([0-9]?[0-9]):[0-9][0-9]\.[0-9][0-9]/\1/')
            VarSec=$(echo $VarTime | sed -r 's/[0-9]?[0-9]:([0-9][0-9])\.[0-9][0-9]/\1/')
            VarHSec=$(echo $VarTime | sed -r 's/[0-9]?[0-9]:[0-9][0-9](\.[0-9][0-9])/\1/')
        else
            VarHours=$(echo $VarTime | sed -r 's/([0-9]?[0-9]):[0-9][0-9]:[0-9][0-9]/\1/')
            VarMin=$(echo $VarTime | sed -r 's/[0-9]?[0-9]:([0-9][0-9]):[0-9][0-9]/\1/')
            VarSec=$(echo $VarTime | sed -r 's/[0-9]?[0-9]:[0-9][0-9]:([0-9][0-9])/\1/')
        fi
        VarTimeSecOnly=$(( 3600*$VarHours + 60*$VarMin + $VarSec ))
        VarTime=$VarTimeSecOnly$VarHSec
        echo -e "$JobId,$TH3IFDEFNO,$SimExitCode,$VarExitCode,$DiffErrors,$ErrOnlyInSim,$ErrOnlyInVar,$OkInBoth,$SameErrors,$TestOnlyInSim,$TestOnlyInVar,$VarTime,$SimTime,$TESTDIRBASE,$TH3CFGBASE,$IFCONFIGBASE" >> $sqliteResultDir/featurewise.csv
    done
fi

#pairwise
rm -rf $sqliteResultDir/pairwise.csv
if [ $PairwiseDirectories -gt 0 ]; then
    echo $Header >> $sqliteResultDir/pairwise.csv
    for dir in $sqliteResultDir/pr_*
    do
        JobId=$(basename $dir | sed 's/pr_//')
        TESTDIRNO=$(( ($JobId / ($CFGFILES * $IFCONFIGSPR)) + 1 )); TESTDIR=$(find ../TH3 -name '*test' ! -path "*/TH3/stress/*" -printf '%h\n' | sort -u | head -n $TESTDIRNO | tail -n 1); TESTDIRBASE=$(basename $TESTDIR)
        TH3CFGNO=$(( (($JobId / $IFCONFIGSPR) % $CFGFILES)  + 1 )); TH3CFG=$(find ../TH3/cfg/ -name "*.cfg"  ! -name "cG.cfg" | sort | head -n $TH3CFGNO | tail -n 1); TH3CFGBASE=$(basename $TH3CFG)
        IFCONFIGNO=$(( ($JobId % $IFCONFIGSPR) + 1 )); IFCONFIG=$(find ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/ -name "id2i_optionstruct_*.h" | sort | head -n $IFCONFIGNO | tail -n 1); IFCONFIGBASE=$(basename $IFCONFIG)
        TH3IFDEFNO=$(( $JobId / $IFCONFIGSPR ))

        DiffErrors=0; if [ -a $dir/DiffErrors.txt ]; then DiffErrors=$(grep -P "^[^\s]" $dir/DiffErrors.txt | wc -l); fi
        ErrOnlyInSim=0; if [ -a $dir/ErrOnlyInSim.txt ]; then ErrOnlyInSim=$(grep -P "^[^\s]" $dir/ErrOnlyInSim.txt | wc -l); fi
        ErrOnlyInVar=0; if [ -a $dir/ErrOnlyInVar.txt ]; then ErrOnlyInVar=$(grep -P "^[^\s]" $dir/ErrOnlyInVar.txt | wc -l); fi
        OkInBoth=0; if [ -a $dir/OkInBoth.txt ]; then OkInBoth=$(grep -P "^[^\s]" $dir/OkInBoth.txt | wc -l); fi
        SameErrors=0; if [ -a $dir/SameErrors.txt ]; then SameErrors=$(grep -P "^[^\s]" $dir/SameErrors.txt | wc -l); fi
        TestOnlyInSim=0; if [ -a $dir/TestOnlyInSim.txt ]; then TestOnlyInSim=$(grep -P "^[^\s]" $dir/TestOnlyInSim.txt | wc -l); fi
        TestOnlyInVar=0; if [ -a $dir/TestOnlyInVar.txt ]; then TestOnlyInVar=$(grep -P "^[^\s]" $dir/TestOnlyInVar.txt | wc -l); fi
        SimTime=$(sed -nr 's/.*real:([0-9]?[0-9]:[0-9][0-9]:[0-9][0-9]|[0-9]?[0-9]:[0-9][0-9]\.[0-9][0-9]).*/\1/p' $dir/time_simulator.txt)
        VarTime=$(sed -nr 's/.*real:([0-9]?[0-9]:[0-9][0-9]:[0-9][0-9]|[0-9]?[0-9]:[0-9][0-9]\.[0-9][0-9]).*/\1/p' $dir/time_variant.txt)
        echo -e "$JobId,$DiffErrors,$ErrOnlyInSim,$ErrOnlyInVar,$OkInBoth,$SameErrors,$TestOnlyInSim,$TestOnlyInVar,$VarTime,$SimTime,$TESTDIRBASE,$TH3CFGBASE,$IFCONFIGBASE,$TH3IFDEFNO" >> $sqliteResultDir/pairwise.csv
    done
fi
exit