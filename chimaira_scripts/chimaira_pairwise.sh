#!/bin/bash
#SBATCH -o /home/garbe/logs/pairwise-%a.txt
#SBATCH --job-name=sqlite-pairwise
#SBATCH -p chimaira
#SBATCH -A spl
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --array=0-3119

#SBATCH --time=04:00:00 # 4 hours max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
##SBATCH --exclusive        #remove for easier apps experiment

# 10 sqlite cfgs; 26 test cfgs; 10 test folders
# 10*26*12 = 3120 different test scenarios

taskName="hercules-sqlite-pairwise"
localDir=/local/garbe
resultDir=~/sqlite
lastJobNo=3119

# Call this script as follows:
# sbatch slurm_pairwise.sh

echo =================================================================
echo % HERCULES SQLITE PAIRWISE\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir

cd TypeChef-SQLiteIfdeftoif
./parallel_pairwise.sh ${SLURM_ARRAY_TASK_ID} > $resultDir/chp_${SLURM_ARRAY_TASK_ID}.txt 2>&1

# send mail notification for last job
if [ ${SLURM_ARRAY_TASK_ID} -eq $lastJobNo ]; then
    echo "Stop slacking off." | mail -s "Chimaira pairwise job finished." fgarbe@fim.uni-passau.de
fi
