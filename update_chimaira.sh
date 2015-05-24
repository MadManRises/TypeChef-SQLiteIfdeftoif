#!/bin/bash
#SBATCH -o ~/slurm/logfile_update-%j.txt
#SBATCH --job-name=hercules-sqlite-update
#SBATCH -A spl

#SBATCH --time=00:05:00 # 5 minutes max

taskName="hercules-sqlite-update"
localDir=/local/garbe

# Call this script as follows:
# sbatch slurm_pairwise.sh

echo =================================================================
echo % HERCULES SQLITE UPDATE\(s\)
echo =================================================================

cd $localDir

# Initialize
if [ ! -d Hercules-SQLiteIfdeftoif ]; then
    # get SQLITE
    git clone https://github.com/fgarbe/TypeChef-SQLiteIfdeftoif

    # get TH3
    cp -r ~/TH3 .
else
    # update SQLITE
    cd TypeChef-SQLiteIfdeftoif/ && git pull -q && cd -
fi