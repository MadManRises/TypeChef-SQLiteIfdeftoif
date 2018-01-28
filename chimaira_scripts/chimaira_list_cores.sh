#!/bin/bash

for i in `seq -s " " -f %02g 1 17`; do
    sbatch -A anywhere --cpus-per-task=1 -p anywhere --time=00:40:00 -o /home/schuetz/logs/cores-${i}.txt -w chimaira${i} list_cores.sh
done

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
