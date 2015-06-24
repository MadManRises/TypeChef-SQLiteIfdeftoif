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

if [ ! -d TH3 ]; then
    # get TH3
    cp -r ~/TH3 .
fi

if [ ! -d TypeChef ]; then
    # get TypeChef
    git clone https://github.com/aJanker/TypeChef.git
    ./TypeChef/publish.sh
else
    # update TypeChef
    cd TypeChef
    if [ "$(git pull)" != "Already up-to-date." ]; then
    ./publish.sh
    fi
    cd $OLDPWD
fi

if [ ! -d Hercules ]; then
    # get Hercules
    git clone https://github.com/joliebig/Hercules.git
    ./Hercules/mkrun.sh
else
    # update Hercules
    cd Hercules
    if [ "$(git pull)" != "Already up-to-date." ]; then
    ./mkrun.sh
    fi
    cd $OLDPWD
fi

if [ ! -d TypeChef-SQLiteIfdeftoif ]; then
    # get SQLITE
    git clone https://github.com/fgarbe/TypeChef-SQLiteIfdeftoif
else
    # update SQLITE
    cd TypeChef-SQLiteIfdeftoif/ && git pull && cd $OLDPWD
fi