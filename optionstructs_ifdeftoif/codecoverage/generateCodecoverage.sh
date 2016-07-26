rm -r generated
mkdir generated
python generateHeaders.py
./cppHeadersToId2iConfigs.sh
#replace SQLITE_OS_UNIX with SQLITE_OS_UNIX 1
#find -name id2i_include_*.h | xargs sed -i 's/#define SQLITE_OS_UNIX/#define SQLITE_OS_UNIX 1/g'