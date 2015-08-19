rm -r generated
mkdir generated
./pairwiseConfigs_SPLCATool.sh > splca_output.txt 2>&1
python generateHeaders.py
./cppHeadersToId2iConfigs.sh
#replace SQLITE_OS_UNIX with SQLITE_OS_UNIX 1
find -name Prod*.h | xargs sed -i 's/#define SQLITE_OS_UNIX/#define SQLITE_OS_UNIX 1/g'