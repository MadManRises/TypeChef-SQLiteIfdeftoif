// (from TypeChef PI file)
/*
** An array of names of all compile-time options.  This array should 
** be sorted A-Z.
**
** This array looks large, but in a typical installation actually uses
** only a handful of compile-time options, so most times this array is usually
** rather short and uses little memory space.
*/
static const char * const azCompileOpt[] = {
/* These macros are provided to "stringify" the value of the define
** for those options in which the value is meaningful. */
#if definedEx(SQLITE_CHECK_PAGES)
  "CHECK_PAGES",
#endif
#if definedEx(SQLITE_COVERAGE_TEST)
  "COVERAGE_TEST",
#endif
#if definedEx(SQLITE_ENABLE_CEROD)
  "ENABLE_CEROD",
#endif
#if definedEx(SQLITE_ENABLE_COLUMN_METADATA)
  "ENABLE_COLUMN_METADATA",
#endif
#if definedEx(SQLITE_ENABLE_EXPENSIVE_ASSERT)
  "ENABLE_EXPENSIVE_ASSERT",
#endif
#if (definedEx(SQLITE_ENABLE_FTS4) || definedEx(SQLITE_ENABLE_FTS3))
  "ENABLE_FTS3",
#endif
#if definedEx(SQLITE_ENABLE_FTS4)
  "ENABLE_FTS4",
#endif
#if definedEx(SQLITE_ENABLE_IOTRACE)
  "ENABLE_IOTRACE",
#endif
#if definedEx(SQLITE_ENABLE_LOCKING_STYLE)
  "ENABLE_LOCKING_STYLE=" "SQLITE_ENABLE_LOCKING_STYLE",
#endif
#if definedEx(SQLITE_ENABLE_MEMORY_MANAGEMENT)
  "ENABLE_MEMORY_MANAGEMENT",
#endif
#if definedEx(SQLITE_ENABLE_MEMSYS3)
  "ENABLE_MEMSYS3",
#endif
#if definedEx(SQLITE_ENABLE_MEMSYS5)
  "ENABLE_MEMSYS5",
#endif
#if definedEx(SQLITE_ENABLE_OVERSIZE_CELL_CHECK)
  "ENABLE_OVERSIZE_CELL_CHECK",
#endif
#if definedEx(SQLITE_ENABLE_UPDATE_DELETE_LIMIT)
  "ENABLE_UPDATE_DELETE_LIMIT",
#endif
#if definedEx(SQLITE_HAS_CODEC)
  "HAS_CODEC",
#endif
#if definedEx(SQLITE_HAVE_ISNAN)
  "HAVE_ISNAN",
#endif
#if definedEx(SQLITE_HOMEGROWN_RECURSIVE_MUTEX)
  "HOMEGROWN_RECURSIVE_MUTEX",
#endif
  "MAX_MMAP_SIZE=" "0",
#if definedEx(SQLITE_NO_SYNC)
  "NO_SYNC",
#endif
#if definedEx(SQLITE_OMIT_ANALYZE)
  "OMIT_ANALYZE",
#endif
#if definedEx(SQLITE_OMIT_ATTACH)
  "OMIT_ATTACH",
#endif
#if definedEx(SQLITE_OMIT_AUTOVACUUM)
  "OMIT_AUTOVACUUM",
#endif
#if definedEx(SQLITE_OMIT_BLOB_LITERAL)
  "OMIT_BLOB_LITERAL",
#endif
#if definedEx(SQLITE_OMIT_BUILTIN_TEST)
  "OMIT_BUILTIN_TEST",
#endif
#if definedEx(SQLITE_OMIT_CAST)
  "OMIT_CAST",
#endif
#if definedEx(SQLITE_OMIT_DECLTYPE)
  "OMIT_DECLTYPE",
#endif
#if definedEx(SQLITE_OMIT_DEPRECATED)
  "OMIT_DEPRECATED",
#endif
#if definedEx(SQLITE_OMIT_EXPLAIN)
  "OMIT_EXPLAIN",
#endif
#if definedEx(SQLITE_OMIT_FOREIGN_KEY)
  "OMIT_FOREIGN_KEY",
#endif
#if definedEx(SQLITE_OMIT_LOAD_EXTENSION)
  "OMIT_LOAD_EXTENSION",
#endif
#if definedEx(SQLITE_OMIT_OR_OPTIMIZATION)
  "OMIT_OR_OPTIMIZATION",
#endif
#if definedEx(SQLITE_OMIT_PAGER_PRAGMAS)
  "OMIT_PAGER_PRAGMAS",
#endif
#if definedEx(SQLITE_OMIT_PRAGMA)
  "OMIT_PRAGMA",
#endif
#if definedEx(SQLITE_OMIT_SUBQUERY)
  "OMIT_SUBQUERY",
#endif
#if definedEx(SQLITE_OMIT_VACUUM)
  "OMIT_VACUUM",
#endif
#if definedEx(SQLITE_OMIT_VIEW)
  "OMIT_VIEW",
#endif
#if definedEx(SQLITE_RTREE_INT_ONLY)
  "RTREE_INT_ONLY",
#endif
#if definedEx(SQLITE_SMALL_STACK)
  "SMALL_STACK",
#endif
  "THREADSAFE=" "1",
};
