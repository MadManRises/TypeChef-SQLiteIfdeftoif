import csv
from collections import defaultdict

columns = defaultdict(list)
final_list = []
define = "#define "

with open("generatedConfigs.ca2.csv") as f:
    reader = csv.reader(f,delimiter=';')
    reader.__next__()
    for row in reader:
        for (i,v) in enumerate(row):
            columns[i].append(v)

i = 0
j = 0
length = len(columns)
for col in columns:
    if i > 0:
        prod = ""
        for val in columns[i]:
            if val == 'X':
                prod = prod + define + columns[0][j] + "\n"
            j += 1
        j = 0
        final_list.append(prod)
        current_index = i-1
        file = open("generated/Prod" + str("%03d" % current_index) + ".h", "w")
        file.write(prod)
        file.close
    i += 1