#!/bin/bash

java -Xmx5500m -jar /local/SPLCATool_Workspace/SPLCAT.jar \
-t t_wise -a ICPL -fm ../../sqlite.dimacs -s 2 \
-focusVariables focusVariables.txt \
-o generatedConfigs.ca2.csv \
-moreConstraints moreConstraints.dimacs \
-hideUnderscoreVariables
