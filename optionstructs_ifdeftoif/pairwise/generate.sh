rm -r generated
mkdir generated
./generatePairwiseConfigs_SPLCATool.sh
python generateHeaders.py
./cppHeadersToId2iConfigs.sh
#replace SQLITE_OS_UNIX with SQLITE_OS_UNIX 1
find -name Prod*.h | xargs sed -i 's/#define SQLITE_OS_UNIX/#define SQLITE_OS_UNIX 1/g'