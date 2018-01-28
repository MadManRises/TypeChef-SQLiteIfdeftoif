#!/bin/bash

for i in `seq -s " " -f %02g 1 17`; do
    sbatch -A anywhere --cpus-per-task=1 -p anywhere --time=00:40:00 -o /home/schuetz/logs/reset-${i}.txt -w chimaira${i} reset_local.sh
done

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
