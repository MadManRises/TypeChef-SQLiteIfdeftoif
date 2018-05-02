#!/bin/bash
#if [[ ! $1 == *.txt ]]; then
#    echo "No .txt file provided"
#    exit
#fi

#csvFile=$(echo $1 | sed 's/.txt/.csv/g')

resultDirectory=/scratch/$USER 

for i in `seq 1 10`; do
    if [ -d "$resultDirectory/Run_$i" ]; then
        echo "Evaluating Run $i..."
        /bin/bash ./eval_csv.sh $i
        cp $resultDirectory/Run_$i/results_sorted.csv ./prediction\ results/results_sorted_$i.csv
	cp $resultDirectory/Run_$i/times_measurements.csv ./prediction\ results/times_measurements_$i.csv
    fi
done


exit
