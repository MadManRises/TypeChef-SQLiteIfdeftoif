from __future__ import print_function
import sys
import csv
from collections import defaultdict

columns = defaultdict(list)
final_list = []
define = "#define "
undefine = "#undef "

with open("generatedConfigs.ca2.csv") as f:
    reader = csv.reader(f,delimiter=';')
    if sys.version > '3':
        reader.__next__() ## Python 3.x uses __next__()
    else:
        reader.next() ## Python 2.x uses next
    for row in reader:
        for (i,v) in enumerate(row):
            columns[i].append(v)
i = 0
j = 0
exported_files = 0
for col in columns:
    if i > 0:
        prod = ""
        is_empty = ""
        for val in columns[i]:
            if val == 'X':
                prod = prod + define + columns[0][j] + "\n"
                is_empty = is_empty + define + "\n"
            else:
                prod = prod + undefine + columns[0][j] + "\n"
            j += 1
        j = 0
        # Check if we actually turned on at least one option in this column
        if is_empty != "":
            final_list.append(prod)
            current_index = i-1
            file = open("generated/Prod" + str("%03d" % current_index) + ".h", "w")
            file.write(prod)
            file.close
            exported_files += 1
    i += 1

print("Exported", exported_files, "Prod.h files from generatedConfigs.ca2.csv file.")
