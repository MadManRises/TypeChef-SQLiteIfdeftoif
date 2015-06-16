#!/bin/bash

# Alter the given .h file to match the format of a .config file
mkdir feature-wise/tmp
for f in ./feature-wise/id2i_include*.h;
do
    sed 's/#define \([A-Z_]*\)$/\1=y/g' $f > feature-wise/tmp/$(basename $f .h).config
done

cd ../
for c in ./optionstructs_ifdeftoif/feature-wise/tmp/id2i_include*.config;
do
     # Start Hercules; only struct generation with the .config files
    ./../Hercules/ifdeftoif.sh --featureConfig $c
    configID=$(basename $c | sed 's/id2i_include_//' | sed 's/.config//')
    mv ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/feature-wise/id2i_optionstruct_$configID.h
    rm $c
done
rm -rf ../ifdeftoif/id2i_optionstruct.h optionstructs_ifdeftoif/feature-wise/tmp
