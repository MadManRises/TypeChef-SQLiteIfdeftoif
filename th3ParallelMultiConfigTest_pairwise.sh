#!/bin/bash

trap "kill 0" SIGINT

# Use gcc version 4.8 if possible
GCC="gcc"
if [ ! -z "$(command -v gcc-4.8)" ]; then
    GCC="gcc-4.8"
fi

rm -f pairwise_*.txt
./ifdeftoifParallel_fixed.sh

echo -e "Pairwise parallel starts at $(date +"%T")"

cd ../TH3
for th3configFile in ../TH3/cfg/*.cfg;
do
	#generate test
	for dir in */;
	do
		# Check if current folder contains *.test files
		count=`ls -1 $dir/*.test 2>/dev/null | wc -l`
		if [ $count != 0 -a $dir != "stress/" ]
		then 			
			for f in ../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/id2i_optionstruct*.h;
			do
				#sed filters everything but the number of the configuration
                configID=$(basename $f | sed 's/id2i_optionstruct_//' | sed 's/.h//')
				( cd ..
				if [ ! -d "tmp_p$configID" ]; then
                    mkdir tmp_p$configID
                fi
				#generate TH3 test file
                cd TH3
                ./mkth3.tcl $dir/*.test "$th3configFile" > ../tmp_p$configID/th3_generated_test.c
			    cd ../tmp_p$configID

				cp th3_generated_test.c th3_generated_test_ifdeftoif.c
				#insert /* Alex: added initialization of our version of the azCompileOpt array */ init_azCompileOpt();
				sed -i \
					's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\/* Alex: added initialization of our version of the azCompileOpt array *\/ init_azCompileOpt()\;/' \
					th3_generated_test_ifdeftoif.c
				#better never touch this sed again

                # Copy files used for compilation into temporary directory
				cp $f id2i_optionstruct.h
				cp ../TypeChef-SQLiteIfdeftoif/sqlite3_ifdeftoif.c sqlite3_ifdeftoif.c
				cp ../TypeChef-SQLiteIfdeftoif/sqlite3.h sqlite3.h

				echo "testing #ifConfig $f on .test files in $dir with th3Config $th3configFile at $(date +"%T")"
				
				# Test normal sqlite
				originalGCC=$($GCC -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
					-include "../TypeChef-SQLiteIfdeftoif/optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
					../TypeChef-SQLiteIfdeftoif/sqlite3_original.c th3_generated_test.c 2>&1)
				# If gcc returns errors skip the testing
				if [ $? != 0 ]
				then
					echo -e "TH3 test can't compile original, skipping test; original GCC error:\n$originalGCC\n\n"
				else
					expectedTestResult=$(bash -c '(./a.out); exit $?' 2>&1)
					expectedOutputValue=$?
					rm -f a.out

					# Test ifdeftoif sqlite
					ifdeftoifGCC=$($GCC -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
						sqlite3_ifdeftoif.c th3_generated_test_ifdeftoif.c 2>&1)
					# If gcc returns errors don't start testing the ifdeftoif variant
					if [ $? != 0 ]
					then
						echo -e "TH3 test can't compile ifdeftoif; expected: $expectedOutputValue\nExpected test output:"
						echo -e "$expectedTestResult" | tail -n 10
						echo -e "\nIfdeftoif GCC error:"
						echo -e "$ifdeftoifGCC"
						echo -e "\n"
					else
						ifdeftoifTestResult=$(bash -c '(./a.out); exit $?' 2>&1)
						testOutputValue=$?
						if [ $testOutputValue -eq $expectedOutputValue ] ; then
                            # echo -e "$expectedTestResult"
							echo -e "Test successful, exit Codes: $testOutputValue;\n\n"
						else
							if [ $expectedOutputValue -eq 0 ] ; then
								echo -e "TH3 succeeds, ifdeftoif does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nIfdeftoif test output:"
								echo -e "$ifdeftoifTestResult" | tail -n 10
								echo -e "\n"
							else
								if [ $testOutputValue -eq 0 ] ; then
									echo -e "Ifdeftoif succeeds, TH3 does not; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nExpected test output:"
									echo -e "$expectedTestResult" | tail -n 10
									echo -e "\n"
								else
									echo -e "TH3 test differs; ifdeftoif: $testOutputValue ; expected: $expectedOutputValue\nExpected test output:"
									echo -e "$expectedTestResult" | tail -n 10
									echo -e "\nIfdeftoif test output:"
									echo -e "$ifdeftoifTestResult" | tail -n 10
									echo -e "\n"
								fi
							fi 
						fi
						rm -f a.out
					fi
				fi
				#delete all temporary contents
				rm -rf *; ) 2>&1 >> ../TypeChef-SQLiteIfdeftoif/pairwise_$configID.txt &
			done
            wait
		fi
	done
done
cd ..
rm -rf tmp_p*
cd TypeChef-SQLiteIfdeftoif/
rm -f th3_pairwise.txt
cat pairwise_*.txt > th3_pairwise.txt
rm -f pairwise_*.txt
echo -e "Pairwise parallel finished at $(date +"%T")"
exit