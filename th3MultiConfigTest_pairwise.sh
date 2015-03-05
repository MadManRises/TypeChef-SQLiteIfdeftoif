#!/bin/bash

if [ ! -f sqlite3_ifdeftoif.c ]; then
./ifdeftoif_mod.sh
fi

for th3configFile in ../TH3/cfg/*.cfg;
do
	#generate test
	cd ../TH3

	for dir in */;
	do
		# Check if current folder contains *.test files
		count=`ls -1 $dir/*.test 2>/dev/null | wc -l`
		if [ $count != 0 -a $dir != "stress/" ]
		then 
			./mkth3.tcl $dir/*.test "$th3configFile" > ../TypeChef-SQLiteIfdeftoif/th3_generated_test.c
			cd ../TypeChef-SQLiteIfdeftoif
			
			cp th3_generated_test.c th3_generated_test_ifdeftoif.c
			#insert /* Alex: added initialization of our version of the azCompileOpt array */ init_azCompileOpt();
			sed -i \
				's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\/* Alex: added initialization of our version of the azCompileOpt array *\/ init_azCompileOpt()\;/' \
				th3_generated_test_ifdeftoif.c
			#better never touch this sed again
			
			for f in ./optionstructs_ifdeftoif/pairwise/generated/id2i_optionstruct_*.h;
			do
				#sed filters everything but the number of the configuration
				configID=$(basename $f | sed 's/id2i_optionstruct_//' | sed 's/.h//')
				echo "testing #ifConfig $f on .test files in $dir with th3Config $th3configFile at $(date +"%T")"
				

				# Test normal sqlite
				gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
					-include "./optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
					sqlite3_original.c th3_generated_test.c
				#disabled all warnings! -w
				./a.out
				expectedOutputValue=$?
				echo "TH3 non-ifdeftoif test result: $expectedOutputValue"
				rm -f a.out
				

				# Test ifdeftoif sqlite
				cp $f ../ifdeftoif/id2i_optionstruct.h
				gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
					-include "./optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
					sqlite3_ifdeftoif.c th3_generated_test_ifdeftoif.c
				#disabled all warnings! -w
				./a.out
				testOutputValue=$?
				echo "TH3 ifdeftoif test result: $testOutputValue"
				if [ $testOutputValue -eq $expectedOutputValue ] ; then
					echo -e "Test successful\n"
				else 
					echo -e "TH3 test differs, ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\n"
				fi
				rm -f a.out
			done
			cd ../TH3
		fi 
	done
done
