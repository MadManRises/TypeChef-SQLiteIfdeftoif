#!/bin/bash

if [ ! -f sqlite3_ifdeftoif.c ]; then
./ifdeftoif_mod.sh
fi

for th3configFile in ../TH3/cfg/*.cfg;
do
	#generate test
	cd ../TH3
	./mkth3.tcl bugs/*.test "$th3configFile" > ../TypeChef-SQLiteIfdeftoif/th3_generated_test.c
	./mkth3.tcl bugs/*.test "$th3configFile" > ../TypeChef-SQLiteIfdeftoif/th3_generated_test_ifdeftoif.c
	cd ../TypeChef-SQLiteIfdeftoif
	
	#insert /* Alex: added initialization of our version of the azCompileOpt array */ init_azCompileOpt();
	sed -i \
		's/int main(int argc, char \*\*argv){/int main(int argc, char \*\*argv){\/* Alex: added initialization of our version of the azCompileOpt array *\/ init_azCompileOpt()\;/' \
		th3_generated_test_ifdeftoif.c
	#better never touch this sed again
	
	for f in ./optionstructs_ifdeftoif/pairwise/generated/id2i_optionstruct_*.h;
	do
		#sed filters everything but the number of the configuration
		configID=$(basename $f | sed 's/id2i_optionstruct_//' | sed 's/.h//')
		
		gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
			-include "./optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
			sqlite3_original.c th3_generated_test.c
		#disabled all warnings! -w
		./a.out
		expectedOutputValue=$?
		echo "TH3 test result: $?"
		rm -f a.out
		
		echo "testing pairwise #ifConfig $f on th3Config $th3configFile"
		cp $f ../ifdeftoif/id2i_optionstruct.h
		rm -f a.out
		gcc -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
			-include "./optionstructs_ifdeftoif/pairwise/generated/Prod$configID.h" \
			sqlite3_ifdeftoif.c th3_generated_test_ifdeftoif.c
		#disabled all warnings! -w
		./a.out
		echo -e "TH3 test result: $?\n"
		if ($? == $expectedOutputValue) then
			echo -e "Test successful\n"
		else 
			echo -e "Test result differs\n"
		fi
		rm -f a.out
	done
done
