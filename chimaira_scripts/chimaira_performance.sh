#!/bin/bash
#SBATCH -o /home/schuetz/logs/perf-%a.txt
#SBATCH --job-name=sqlite-th3
#SBATCH -p chimaira
#SBATCH -A schuetz
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --mem=13000
#SBATCH --array=0-299

#SBATCH --time=02:00:00 # 1h30m max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
##SBATCH --exclusive        #remove for easier apps experiment

# 25 test cfgs; 12 test folders
# 25*12 = 300 different test scenarios

taskName="hercules-sqlite-th3"
localDir=/local/schuetz
resultDir=~/sqlite
lastJobNo=300

# Call this script as follows:
# sbatch slurm_featurewise.sh

echo =================================================================
echo % HERCULES TH3 GENERATION\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir
cd TypeChef-SQLiteIfdeftoif
# Use java 8
export PATH=/usr/lib/jvm/jdk-8-oracle-x64/bin/:$PATH
./parallel_th3_test_performance.sh ${SLURM_ARRAY_TASK_ID}

 #send mail notification for last job
if [ ${SLURM_ARRAY_TASK_ID} -eq $lastJobNo ]; then
    echo "Stop slacking off." | mail -s "Chimaira TH3 job finished." schuetzo-martin@web.de
fi
