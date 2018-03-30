#!/bin/bash
#SBATCH -o /scratch/schuetz/logs/perf-pr-%a.txt
#SBATCH --job-name=sqlite-perf-pairwise
#SBATCH -p anywhere
#SBATCH -A anywhere
#SBATCH --constrain=chimaira
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --mem=10000
#SBATCH --array=100,152,162,168,170,171

#SBATCH --time=24:00:00 # 4h max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
#SBATCH --exclusive        #remove for easier apps experiment

#SBATCH --cpu-freq=Performance
#SBATCH --pstate-turbo=off

# 25 sqlite cfgs; 26 test cfgs; 10 test folders
# 25*26*12 = 7800 different test scenarios

taskName="hercules-sqlite-perf-pairwise"
localDir=/local/schuetz
resultDir=~/sqlite
lastJobNo=7799

# Call this script as follows:
# sbatch slurm_featurewise.sh

echo =================================================================
echo % HERCULES SQLITE FEATUREWISE\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir

/scratch/schuetz/TypeChef-SQLiteIfdeftoif/performance_pairwise.sh ${SLURM_ARRAY_TASK_ID}

# send mail notification for last job
if [ ${SLURM_ARRAY_TASK_ID} -eq $lastJobNo ]; then
    echo "Stop slacking off." | mail -s "Chimaira featurewise job finished." schuetzo-martin@web.de
fi
