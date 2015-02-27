#!/bin/bash

# Alter the given .h file to match the format of a .config file
mkdir generated/tmp
for f in ./generated/Prod*.h;
do
    sed 's/#define \([A-Z_]*\)$/\1=y/g' $f > generated/tmp/$(basename $f .h).config
done

cd ../../
for c in ./optionstructs_ifdeftoif/pairwise/generated/tmp/Prod*.config;
do
     # Start Hercules; only struct generation with the .config files
    ./../Hercules/ifdeftoif.sh --featureConfig $c
    configID=$(basename $c | sed 's/Prod//' | sed 's/.config//')
    mv ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/pairwise/generated/id2i_optionstruct_$configID.h
    rm $c
done
rm -rf ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/pairwise/generated/tmp
