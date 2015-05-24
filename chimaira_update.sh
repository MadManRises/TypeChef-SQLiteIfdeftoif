#!/bin/bash

for i in `seq -w 1 17`: do
    sbatch -w chimaira${i} update_chimaira.sh
done