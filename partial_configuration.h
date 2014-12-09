// lexer error tcl.h not found
// sqlite3.c line 456
#undef SQLITE_TCL
#undef TCLSH

// lexer error windows.h not found
// sqlite3.c line 9481
#define SQLITE_OS_WIN 0

// since we want to build sqlite for linux, turn all other os off
#define OS_VXWORKS 0
#define SQLITE_OTHER_OS 0
#define __OpenBSD__ 0
#define SQLITE_OS_UNIX 1


// lexer error malloc/malloc.h not found
// sqlite3.c line 15528
#undef __APPLE__

// lexer error unicode/utypes.h not found
// sqlite3.c line 137385
#define SQLITE_CORE
#undef SQLITE_ENABLE_ICU

// lexer error unknown user defined type
// sqlite3.pi line 6711
#undef __BORLANDC__
#undef _MSC_VER

// type error malloc_usable_size undeclared
// sqlite3.pi line 40999
#define SQLITE_SYSTEM_MALLOC
#undef SQLITE_ZERO_MALLOC
#define HAVE_MALLOC_H
#define HAVE_MALLOC_USABLE_SIZE
// related to #error
#undef SQLITE_WIN32_MALLOC
#undef SQLITE_MEMDEBUG
#undef SQLITE_ZERO_MALLOC

// type error yy_parse_failed undeclared
// sqlite3.pi line 168484
#undef YYERRORSYMBOL

// type error Type Wal not defined
// sqlite3.pi line 77984
#undef SQLITE_OMIT_WAL
#undef SQLITE_OMIT_DISKIO

// type error sqlite3VdbeExpandSql undeclared
// sqlite3.pi line 101167
#undef SQLITE_OMIT_FLOATING_POINT
#undef SQLITE_OMIT_TRACE

// several type errors
#undef SQLITE_OMIT_TRIGGER

// type error selectOpName undeclared
// sqlite3.pi line 152449
#undef SQLITE_OMIT_COMPOUND_SELECT

// type error mutexShared undeclared
// sqlite3.pi line 84122
#undef SQLITE_OMIT_SHARED_CACHE
#undef SQLITE_MUTEX_OMIT

// several type errors; e.g., Tcl_Obj undeclared
// sqlite3.pi line 186030
#undef SQLITE_TEST

// several type errors
// incorrect assignment
// Constant(0) is not a function, but has type CZero()
// sqlite3.pi line 193973
#undef SQLITE_ENABLE_RTREE

// several type errors
// incorrect assignment
// sqlite3.pi line 187806
#undef SQLITE_OMIT_VIRTUALTABLE

// optional macro used for compatibiliy reasons with older versions of sqlite (sqlite3.c line 361)
#undef THREADSAFE

// configuration error; cpp macro defined but has no value
#if defined(SQLITE_THREADSAFE)
    #define SQLITE_THREADSAFE 1
#endif

// causes several type errors
#undef NDEBUG

#undef SQLITE_DEBUG

//03.12. Fix SQLITE_THREADSAFE=0 in partialConfiguration.h (cannot assign values in pc). From the documentation:
//	"The pthreads library is needed to make SQLite threadsafe. 
//	But since the CLI is single threaded, we could instruct SQLite to build in a non-threadsafe mode and thereby omit the pthreads library:
//	gcc -DSQLITE_THREADSAFE=0 shell.c sqlite3.c -ldl"

#define SQLITE_THREADSAFE 0

// 9.12. Fix a warning in TypeChef
#define SQLITE_MALLOC_SOFT_LIMIT 1024
// 9.12. Fix a warning in TypeChef, only one process per file db possible with this.
#define SQLITE_ENABLE_LOCKING_STYLE 0
//9.12. Choose exactly one MALLOC strategy. TypeChef lexer cannot process an #if otherwise (#if .. + .. > 1).
#define SQLITE_SYSTEM_MALLOC 1
#undef SQLITE_WIN32_MALLOC
#undef SQLITE_ZERO_MALLOC
#undef SQLITE_MEMDEBUG

// 9.12. Online doc says we cannot use this option. http://www.sqlite.org/compile.html
#undef SQLITE_ENABLE_UPDATE_DELETE_LIMIT
