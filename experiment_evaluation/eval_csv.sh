#!/bin/bash
#if [[ ! $1 == *.txt ]]; then
#    echo "No .txt file provided"
#    exit
#fi

#csvFile=$(echo $1 | sed 's/.txt/.csv/g')

resultDirectory=/scratch/$USER/Run_1
herculesDir=/home/$USER/Hercules/performance
timesFile=$resultDirectory/times_measurements.csv
resultFile=$resultDirectory/results_sorted.csv

cd $herculesDir

#rm -rf $resultDirectory/*.csv
header="RunID,InputMode,PredictMode,ConfigID,PredictedTime,Variance,PerfTime,SimTime,VarTime,AccPerf,AccVar"

rm -rf $timesFile
times_header="ID,CfgID,Mode,Measurements,Time,Overhead,SimTime,VarTime"
echo $times_header >> $timesFile

rm -rf $resultFile
results_header="id,InputMode,PredictMode,PercentageError,PercentageErrorInclVariance,VariancePercentage,MPTimePrediction,MPTimeResult,MPSharedFeatureDeviation,MPSharedFeatureDeviationInclVariance"
echo $results_header >> $resultFile



# pairwise predicts featurewise
echo "pairwise predicts featurewise"
rm -rf $resultDirectory/pairwisePredictsFeaturewise.csv
echo $header >> $resultDirectory/pairwisePredictsFeaturewise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im pairwise -pm featurewise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_ft_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_ft_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_ft_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,pr,ft,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            echo $csvLine >> $resultDirectory/pairwisePredictsFeaturewise.csv

            measurements=$(grep -o -E 'Measurement counter: [0-9]+' $resultDirectory/$i/perf_ft_$paddedCounter.txt | grep -o '[0-9]*')
            overhead=$(grep -o -E 'overhead: [0-9.]+' $resultDirectory/$i/perf_ft_$paddedCounter.txt | grep -o '[0-9.]*')

            timesLine="$i,$counter,featurewise,$measurements,$perfTime,$overhead,$simTime,$varTime"
            echo $timesLine >> $timesFile

            counter=$(( $counter + 1))

        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')


        resultLine="$i,pairwise,featurewise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile

    fi

done

#random predicts featurewise
echo "random predicts featurewise"
rm -rf $resultDirectory/randomPredictsFeaturewise.csv
echo $header >> $resultDirectory/randomPredictsFeaturewise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im random -pm featurewise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,rnd,ft,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/randomPredictsFeaturewise.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,random,featurewise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi
done

#allyes predicts featurewise
echo "allyes predicts featurewise"
rm -rf $resultDirectory/allyesPredictsFeaturewise.csv
echo $header >> $resultDirectory/allyesPredictsFeaturewise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im allyes -pm featurewise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_ft_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_ft_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_ft_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,ay,ft,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/allyesPredictsFeaturewise.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,allyes,featurewise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
     fi

done

# featurewise predicts pairwise
echo "featurewise predicts pairwise"
rm -rf $resultDirectory/featurewisePredictsPairwise.csv
echo $header >> $resultDirectory/featurewisePredictsPairwise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im featurewise -pm pairwise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_pr_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_pr_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_pr_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,ft,pr,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            echo $csvLine >> $resultDirectory/featurewisePredictsPairwise.csv

            measurements=$(grep -o -E 'Measurement counter: [0-9]+' $resultDirectory/$i/perf_pr_$paddedCounter.txt | grep -o '[0-9]*')
            overhead=$(grep -o -E 'overhead: [0-9.]+' $resultDirectory/$i/perf_pr_$paddedCounter.txt | grep -o '[0-9.]*')

            timesLine="$i,$counter,pairwise,$measurements,$perfTime,$overhead,$simTime,$varTime"
            echo $timesLine >> $timesFile

            counter=$(( $counter + 1))

        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

           percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,featurewise,pairwise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done

#random predicts pairwise
echo "random predicts pairwise"
rm -rf $resultDirectory/randomPredictsPairwise.csv
echo $header >> $resultDirectory/randomPredictsPairwise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im random -pm pairwise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,rnd,pr,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/randomPredictsPairwise.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,random,pairwise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done

#allyes predicts pairwise
echo "allyes predicts pairwise"
rm -rf $resultDirectory/allyesPredictsPairwise.csv
echo $header >> $resultDirectory/allyesPredictsPairwise.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im allyes -pm pairwise -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_pr_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_pr_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_pr_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,ay,pr,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/allyesPredictsPairwise.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,allyes,pairwise,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done

#featurewise predicts random
echo "featurewise predicts random"
rm -rf $resultDirectory/featurewisePredictsRandom.csv
echo $header >> $resultDirectory/featurewisePredictsRandom.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im featurewise -pm random -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,ft,rnd,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/featurewisePredictsRandom.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,featurewise,random,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done

#pairwise predicts random
echo "pairwise predicts random"
rm -rf $resultDirectory/pairwisePredictsRandom.csv
echo $header >> $resultDirectory/pairwisePredictsRandom.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im pairwise -pm random -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,pr,rnd,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            counter=$(( $counter + 1))
            echo $csvLine >> $resultDirectory/pairwisePredictsRandom.csv


        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,pairwise,random,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done


#allyes predicts random
echo "allyes predicts random"
rm -rf $resultDirectory/allyesPredictsRandom.csv
echo $header >> $resultDirectory/allyesPredictsRandom.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im allyes -pm random -f $resultDirectory/$i/)
        counter=0
        while read -r line
        do
            paddedCounter=$(printf %03d $counter)
            simTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            varTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_rnd_$paddedCounter.txt | grep -o '[0-9.]*')
            perfTime=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            predictedTime=$(echo $line | grep -o -E 'Predicted: [0-9.]+' | grep -o '[0-9.]*')
            predictedVariance=$(echo $line | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
            csvLine="$i,ay,rnd,$counter,$predictedTime,$predictedVariance,$perfTime,$simTime,$varTime"
            echo $csvLine >> $resultDirectory/allyesPredictsRandom.csv

            measurements=$(grep -o -E 'Measurement counter: [0-9]+' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9]*')
            overhead=$(grep -o -E 'overhead: [0-9.]+' $resultDirectory/$i/perf_rnd_$paddedCounter.txt | grep -o '[0-9.]*')

            timesLine="$i,$counter,random,$measurements,$perfTime,$overhead,$simTime,$varTime"
            echo $timesLine >> $timesFile

            counter=$(( $counter + 1))

        done < <(echo $prediction | grep -o -E 'Predicted: [0-9.]+ ms ± [0-9.]+ ms')

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,allyes,random,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done


#featurewise predicts allyes
echo "featurewise predicts allyes"
rm -rf $resultDirectory/featurewisePredictsAllyes.csv
echo $header >> $resultDirectory/featurewisePredictsAllyes.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        simTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_ay.txt | grep -o '[0-9.]*')
        varTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_ay.txt | grep -o '[0-9.]*')
        perfTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_ay.txt | grep -o '[0-9.]*')

        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im featurewise -pm allyes -f $resultDirectory/$i/)
        predictedTime=$(echo $prediction | grep -o -E '^Predicted: [0-9.]+ ms' | grep -o '[0-9.]*')
        predictedVariance=$(echo $prediction | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
        csvLine="$i,ft,ay,0,$predictedTime,$predictedVariance,$perfTimeAy,$simTimeAy,$varTimeAy"
        echo $csvLine >> $resultDirectory/featurewisePredictsAllyes.csv

	    measurements=$(grep -o -E 'Measurement counter: [0-9]+' $resultDirectory/$i/perf_ay.txt | grep -o '[0-9]*')
	    overhead=$(grep -o -E 'overhead: [0-9.]+' $resultDirectory/$i/perf_ay.txt | grep -o '[0-9.]*')

	    timesLine="$i,49,allyes,$measurements,$perfTimeAy,$overhead,$simTimeAy,$varTimeAy"
	    echo $timesLine >> $timesFile

	    percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
      percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
      varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
      MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
      MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
      MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
      MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,featurewise,allyes,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile

    fi
done

#pairwise predicts allyes
echo "pairwise predicts allyes"
rm -rf $resultDirectory/pairwisePredictsAllyes.csv
echo $header >> $resultDirectory/pairwisePredictsAllyes.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        simTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_ay.txt | grep -o '[0-9.]*')
        varTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_ay.txt | grep -o '[0-9.]*')
        perfTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_ay.txt | grep -o '[0-9.]*')

        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im pairwise -pm allyes -f $resultDirectory/$i/)
        predictedTime=$(echo $prediction | grep -o -E '^Predicted: [0-9.]+ ms' | grep -o '[0-9.]*')
        predictedVariance=$(echo $prediction | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
        csvLine="$i,pr,ay,0,$predictedTime,$predictedVariance,$perfTimeAy,$simTimeAy,$varTimeAy"
        echo $csvLine >> $resultDirectory/pairwisePredictsAllyes.csv

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,pairwise,allyes,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done

#random predicts allyes
echo "random predicts allyes"
rm -rf $resultDirectory/randomPredictsAllyes.csv
echo $header >> $resultDirectory/randomPredictsAllyes.csv
for i in `seq 0 299`; do
    if [ -d "$resultDirectory/$i/" ]; then
        simTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/sim_ay.txt | grep -o '[0-9.]*')
        varTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/var_ay.txt | grep -o '[0-9.]*')
        perfTimeAy=$(grep -o -E 'Total time: [0-9.]+ ms' $resultDirectory/$i/perf_ay.txt | grep -o '[0-9.]*')

        prediction=$(java -jar $herculesDir/PerfTimes.jar -cs sqlite -im random -pm allyes -f $resultDirectory/$i/)
        predictedTime=$(echo $prediction | grep -o -E '^Predicted: [0-9.]+ ms' | grep -o '[0-9.]*')
        predictedVariance=$(echo $prediction | grep -o -E '± [0-9.]+ ms' | grep -o '[0-9.]*')
        csvLine="$i,rnd,ay,0,$predictedTime,$predictedVariance,$perfTimeAy,$simTimeAy,$varTimeAy"
        echo $csvLine >> $resultDirectory/randomPredictsAllyes.csv

        percError=$(echo $prediction | grep -o -E 'Absolute mean percentage error: [0-9.]+%' | grep -o '[0-9.]*')
        percErrorInclVar=$(echo $prediction | grep -o -E 'Absolute mean percentage error incl variance: [0-9.]+%' | grep -o '[0-9.]*')
        varPerc=$(echo $prediction | grep -o -E 'Variance percentage: [0-9.]+%' | tail -1 | grep -o '[0-9.]*')
        MPTimePredicition=$(echo $prediction | grep -o -E 'Mean percentage of time only in prediction: [0-9.]+%' | grep -o '[0-9.]*')
        MPTimeResult=$(echo $prediction | grep -o -E 'Mean percentage of time only in result: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviation=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation: [0-9.]+%' | grep -o '[0-9.]*')
        MPSharedFeatureDeviationInclVar=$(echo $prediction | grep -o -E 'Mean percentage of shared feature deviation incl variance: [0-9.]+%' | grep -o '[0-9.]*')

        resultLine="$i,random,allyes,$percError,$percErrorInclVar,$varPerc,$MPTimePredicition,$MPTimeResult,$MPSharedFeatureDeviation,$MPSharedFeatureDeviationInclVar"
        echo $resultLine >> $resultFile
    fi

done


exit
