#!/bin/bash

for i in 02; do
    sbatch -A schuetz --cpus-per-task=1 -p chimaira --time=00:30:00 -o /home/schuetz/logs/update-${i}.txt -w chimaira${i} force_chimaira.sh
done

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
