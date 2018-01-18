#!/bin/bash
#SBATCH -o /home/schuetz/logs/featurewise-%a.txt
#SBATCH --job-name=sqlite-featurewise
#SBATCH -p chimaira
#SBATCH -A schuetz
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --mem=10000
#SBATCH --array=0-6899

#SBATCH --time=04:00:00 # 4h max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
##SBATCH --exclusive        #remove for easier apps experiment

# 23 sqlite cfgs; 25 test cfgs; 12 test folders
# 23*25*12 = 7500 different test scenarios

taskName="hercules-sqlite-featurewise"
localDir=/local/schuetz
resultDir=~/sqlite
lastJobNo=7899

# Call this script as follows:
# sbatch slurm_featurewise.sh

echo =================================================================
echo % HERCULES SQLITE FEATUREWISE\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir

cd TypeChef-SQLiteIfdeftoif
./parallel_featurewise.sh ${SLURM_ARRAY_TASK_ID} > $resultDir/chf_${SLURM_ARRAY_TASK_ID}.txt 2>&1

# send mail notification for last job
if [ ${SLURM_ARRAY_TASK_ID} -eq $lastJobNo ]; then
    echo "Stop slacking off." | mail -s "Chimaira featurewise job finished." schuetzo-martin@web.de
fi
