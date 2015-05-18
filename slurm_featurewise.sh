#!/bin/bash
#SBATCH -o ~/slurm/logfile_featurewise-%j.txt
#SBATCH --job-name=hercules-sqlite
#SBATCH -p chimaira
#SBATCH -A spl
#SBATCH --get-user-env
#SBATCH --ntasks 1
#SBATCH --array=0-4

#SBATCH --time=00:05:00 # 5 minutes max

#SBATCH --cpus-per-task 1   # 1 for easier apps experiment

##SBATCH --cpus-per-task 10     #set to 10 for full chimaira core per apk (60 GB ram)
##SBATCH --exclusive        #remove for easier apps experiment

# 6552 different test scenarios

taskName="hercules-sqlite"
localDir=/local/garbe
resultDir=~/sqlite

# Call this script as follows:
# sbatch slurm_featurewise.sh

echo =================================================================
echo % HERCULES SQLITE FEATUREWISE\(s\)
echo % Task ID: ${SLURM_ARRAY_TASK_ID}
echo % JOB ID: ${SLURM_JOBID}
echo =================================================================

cd $localDir

# Initialize
if mkdir setup.inits 2>/dev/null;
  then
    # get SQLITE
    git clone https://github.com/fgarbe/TypeChef-SQLiteIfdeftoif

    # get TH3
    cp -r ~/TH3 .
    touch setup.done
fi

# wait until initialization is done
while [ ! -f setup.done ]; do sleep 10; done;

# Update
if mkdir update.inits 2>/dev/null;
  then
    # update SQLITE
    cd TypeChef-SQLiteIfdeftoif/ && git pull -q && cd -
    touch update.done
fi

# wait until update is done
while [ ! -f update.done ]; do sleep 10; done;

cd TypeChef-SQLiteIfdeftoif
./chimaira_featurewise.sh ${SLURM_ARRAY_TASK_ID} > $resultDir/chf_${SLURM_ARRAY_TASK_ID}.txt 2>&1