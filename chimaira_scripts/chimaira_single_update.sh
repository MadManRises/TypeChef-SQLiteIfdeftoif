#!/bin/bash

sbatch -A spl --cpus-per-task=1 -p chimaira --time=02:30:00 -o /home/garbe/logs/update-$1.txt -w chimaira$1 update_chimaira.sh

# echo "Stop slacking off." | mail -s "Chimaira update finished." fgarbe@fim.uni-passau.de
