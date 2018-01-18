#!/bin/bash

sbatch -A schuetz --cpus-per-task=1 -p chimaira --time=02:30:00 -o /home/schuetz/logs/update-$1.txt -w chimaira$1 update_chimaira.sh

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
