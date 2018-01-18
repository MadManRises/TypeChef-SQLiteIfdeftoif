#!/bin/bash

collectionDir="./results/"

mkdir ${collectionDir}/

rm -rf ${collectionDir}/DiffErrors.txt
rm -rf ${collectionDir}/ErrOnlyInSim.txt
rm -rf ${collectionDir}/ErrOnlyInVar.txt
rm -rf ${collectionDir}/OkInBoth.txt
rm -rf ${collectionDir}/SameErrors.txt
rm -rf ${collectionDir}/TestOnlyInSim.txt
rm -rf ${collectionDir}/TestOnlyInVar.txt
rm -rf ${collectionDir}/time_sim.txt
rm -rf ${collectionDir}/time_var.txt

for t in /home/schuetz/sqlite/* ; do
	if [ -d $t ]
	then
		cat ${t}/DiffErrors.txt    >> ${collectionDir}/DiffErrors.txt
		cat ${t}/ErrOnlyInSim.txt  >> ${collectionDir}/ErrOnlyInSim.txt
		cat ${t}/ErrOnlyInVar.txt  >> ${collectionDir}/ErrOnlyInVar.txt
		cat ${t}/OkInBoth.txt      >> ${collectionDir}/OkInBoth.txt
		cat ${t}/SameErrors.txt    >> ${collectionDir}/SameErrors.txt
		cat ${t}/TestOnlyInSim.txt >> ${collectionDir}/TestOnlyInSim.txt
		cat ${t}/TestOnlyInVar.txt >> ${collectionDir}/TestOnlyInVar.txt
	fi
done

python TH3_Log_aggregation/log_aggregate.py
