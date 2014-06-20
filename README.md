Hercules casestudy SQLite (v 3.7.16.1)
============================================

1. `TypeChef` and `Hercules` folder must be at ".." relative to this project folder; see project [Hercules](https://github.com/joliebig/Hercules) to install both `TypeChef` and `Hercules`.
2. Run `./ifdeftoif.sh` in this projects directory to start the transformation process on `SQLite`.

Notes
-----------
- openfeatures.txt has been extracted based on #ifdefs in sqlite3.c
- several lexer errors have been fixed and are documented in partial_configuration.h
- several type errors have been fixed and are documented in partial_configuration.h
- two alternatives have been extracted and added to fm.txt
