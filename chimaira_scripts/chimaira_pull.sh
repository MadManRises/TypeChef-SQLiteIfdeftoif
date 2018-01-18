#!/bin/bash

for i in `seq -s " " -f %02g 1 17`; do
    sbatch -A schuetz --cpus-per-task=1 -p chimaira --time=00:10:00 -o /home/schuetz/logs/pull-${i}.txt -w chimaira${i} pull_chimaira.sh
done

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
