#!/bin/bash

sbatch -A schuetz --cpus-per-task=1 -p chimaira --time=00:10:00 -o /home/schuetz/logs/publish.txt force_chimaira.sh

# echo "Stop slacking off." | mail -s "Chimaira update finished." schuetzo-martin@web.de
