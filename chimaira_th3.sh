#!/bin/bash
#SBATCH -o /home/garbe/logs/th3-%a.txt
#SBATCH --job-name=sqlite-th3
#SBATCH -p chimaira
#SBATCH -A spl
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --mem=13000
#SBATCH --array=0-259

#SBATCH --time=01:15:00 # 30 minutes max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
##SBATCH --exclusive        #remove for easier apps experiment

# 259 different test scenarios

taskName="hercules-sqlite-th3"
localDir=/local/garbe
resultDir=~/sqlite
lastJobNo=233

# Call this script as follows:
# sbatch slurm_featurewise.sh

echo =================================================================
echo % HERCULES TH3 GENERATION\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir

cd TypeChef-SQLiteIfdeftoif
./parallel_th3_test_ifdeftoif.sh ${SLURM_ARRAY_TASK_ID}

# send mail notification for last job
if [ ${SLURM_ARRAY_TASK_ID} -eq $lastJobNo ]; then
    echo "Stop slacking off." | mail -s "Chimaira TH3 job finished." fgarbe@fim.uni-passau.de
fi
