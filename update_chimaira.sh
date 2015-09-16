#!/bin/bash

taskName="hercules-sqlite-update"
localDir=/local/garbe

# Call this script as follows:
# chimaira_update.sh
if [ -d $localDir ]; then
    echo =================================================================
    echo % HERCULES SQLITE UPDATE\(s\)
    echo =================================================================

    cd $localDir

    # Initialize


    # get TH3
    rm -rf TH3/
    cp -r ~/TH3 .

    if [ ! -d TypeChef ]; then
        # get TypeChef
        git clone https://github.com/aJanker/TypeChef.git
        ./TypeChef/publish.sh
    else
        # update TypeChef
        cd TypeChef
	    pull=$(git pull 2>&1)
        if [ $pull != "Already up-to-date." ] && [ $pull != *"fatal:"* ]; then
            ./publish.sh
        else
            echo "Skipping publish."
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
else
    echo "Wrong machine? Script cancelled"
fi
