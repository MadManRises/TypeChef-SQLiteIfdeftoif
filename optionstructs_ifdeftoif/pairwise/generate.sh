./generatePairwiseConfigs_SPLCATool.sh
python generateHeaders.py
./cppHeadersToId2iConfigs.sh
#replace SQLITE_OS_UNIX with SQLITE_OS_UNIX 1
find -name Prod*.h | sed -i 's/#define SQLITE_OS_UNIX/#define SQLITE_OS_UNIX 1/g'