#!/bin/bash

taskName="hercules-sqlite-update"
localDir=/local/garbe

# Call this script as follows:
# chimaira_update.sh

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