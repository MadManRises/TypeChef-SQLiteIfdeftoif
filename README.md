Hercules casestudy SQLite (v 3.7.16.1)
============================================

This repository contains the setup for our evaluation of [Hercules](https://github.com/joliebig/Hercules) based on [SQLite](http://sqlite.org/) and its test suite [TH3](https://www.sqlite.org/th3.html).

To run this evaluation, we need `TypeChef`, `Hercules`, and `TH3`.

1. `TypeChef`, `Hercules`, and `TH3` folder must be at ".." relative to this project folder.
See project [Hercules](https://github.com/joliebig/Hercules) to install both `TypeChef` and `Hercules`.
`TH3` is proprietary and requires a license.

2. To enable our evaluation, we had to modify TH3:
 - We changed the file `th3.c` such that it does not print values such as memory sizes or execution times, which cannot be reproduced in comparative tests. We provide a patch with our changes to `th3.c` (`setup/th3.c.patch`).
 - We moved some test files from very large folders to new folder such that the sizes of the corresponding test cases are reduced. We provide an listing of the test files and their folders in `setup/testfile_listing.txt`.

3. Run `parallel_featurewise.sh` to start the evaluation on featurewise configurations and `parallel_pairwise.sh` to start the evaluation on pairwise configurations.

Notes (this repository
-----------
- openfeatures.txt has been extracted based on #ifdefs in sqlite3.c
- several lexer errors have been fixed and are documented in partial_configuration.h
- several type errors have been fixed and are documented in partial_configuration.h
- two alternatives have been extracted and added to fm.txt
