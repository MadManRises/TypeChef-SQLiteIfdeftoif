#!/bin/bash

# Alter the given .h file to match the format of a .config file
mkdir -p generated/tmp
for f in ./generated/id2i_include*.h;
do
    sed 's/#define \([A-Z_0-9]*\)$/\1=y/g' $f > generated/tmp/$(basename $f .h).config
done

#for f in ./generated/id2i_include*.h;
#do
#    comm -3 ../alwayson.txt <(sed 's/#define \([A-Z_0-9]*\)$/\1/g' $f) > generated/$(basename $f .h).info
#done

cd ../../

# Move list of all SQLite and TH3 test features into ifdeftoif folder
mv ../ifdeftoif/featureSet.txt ../ifdeftoif/featureSetTMP.txt
cp featureSet.txt ../ifdeftoif

for c in ./optionstructs_ifdeftoif/codecoverage/generated/tmp/id2i_include*.config;
do
     # Start Hercules; only struct generation with the .config files
    ./../Hercules/ifdeftoif.sh --featureConfig $c
    configID=$(basename $c | sed 's/id2i_include_//' | sed 's/.config//')
    mv ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/codecoverage/generated/id2i_optionstruct_$configID.h
    rm $c
done
rm -rf ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/codecoverage/generated/tmp

# Move feature list back
mv ../ifdeftoif/featureSetTMP.txt ../ifdeftoif/featureSet.txt