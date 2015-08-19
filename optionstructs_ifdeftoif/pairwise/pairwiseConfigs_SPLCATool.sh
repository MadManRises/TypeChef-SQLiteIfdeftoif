#!/bin/bash

# make sure that limitations in ../ifdeftoifHelpers/custom_limitations.txt
# are reflected in moreConstraints.dimacs

java -Xmx5500m -jar ../SPLCATool.jar \
-t t_wise -a ICPL -fm ../../sqlite_extended.dimacs -s 2 \
-focusVariables focusVariables.txt \
-o generatedConfigs.ca2.csv \
-moreConstraints moreConstraints.dimacs \
-hideUnderscoreVariables
