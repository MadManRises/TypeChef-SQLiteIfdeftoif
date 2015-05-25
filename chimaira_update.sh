#!/bin/bash

for i in `seq -w 1 17`: do
    sbatch -A spl -p chimaira --time=00:05:00 -o ~/slurm/logfile_update-%j.txt -w chimaira${i} update_chimaira.sh
done

echo "Stop slacking off." | mail -s "Chimaira update finished." fgarbe@fim.uni-passau.de