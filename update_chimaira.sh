#!/bin/bash

taskName="hercules-sqlite-update"
localDir=/local/schuetz

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
        cd TypeChef
        java ./sbt-launch.jar update compile
        cd $OLDPWD
    else
        # update TypeChef
        cd TypeChef
	    pull=$(git pull 2>&1)
        if [ $pull != "Already up-to-date." ] && [ $pull != *"fatal:"* ]; then
            java ./sbt-launch.jar update compile
        else
            echo "Skipping TypeChef ./publish.sh"
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
        if [ $pull != "Already up-to-date." ] && [ $pull != *"fatal:"* ]; then
            ./mkrun.sh
        else
            echo "Skipping Hercules ./mkrun.sh"
        fi
        cd $OLDPWD
    fi

    if [ ! -d TypeChef-SQLiteIfdeftoif ]; then
        # get SQLITE
        git clone https://github.com/MadManRises/TypeChef-SQLiteIfdeftoif.git
    else
        # update SQLITE
        cd TypeChef-SQLiteIfdeftoif/ && git pull && cd $OLDPWD
    fi
else
    echo "Wrong machine? Script cancelled"
fi
