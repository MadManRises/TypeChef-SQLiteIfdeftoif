char ** azCompileOpt;

void init_azCompileOpt() {
		int elements = 0;
	// allocate the array with maximum needed length (39)
	azCompileOpt = (char **) malloc( 39 * sizeof(char *)); // array for 1 string

#if definedEx(SQLITE_CHECK_PAGES)
	azCompileOpt[elements] = "CHECK_PAGES";
	elements++;
#endif
#if definedEx(SQLITE_COVERAGE_TEST)
	azCompileOpt[elements] = "COVERAGE_TEST";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_CEROD)
	azCompileOpt[elements] = "ENABLE_CEROD";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_COLUMN_METADATA)
	azCompileOpt[elements] = "ENABLE_COLUMN_METADATA";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_EXPENSIVE_ASSERT)
	azCompileOpt[elements] = "ENABLE_EXPENSIVE_ASSERT";
	elements++;
#endif
#if (definedEx(SQLITE_ENABLE_FTS4) || definedEx(SQLITE_ENABLE_FTS3))
	azCompileOpt[elements] = "ENABLE_FTS3";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_FTS4)
	azCompileOpt[elements] = "ENABLE_FTS4";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_IOTRACE)
	azCompileOpt[elements] = "ENABLE_IOTRACE";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_LOCKING_STYLE)
	azCompileOpt[elements] = "ENABLE_LOCKING_STYLE=SQLITE_ENABLE_LOCKING_STYLE";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_MEMORY_MANAGEMENT)
	azCompileOpt[elements] = "ENABLE_MEMORY_MANAGEMENT";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_MEMSYS3)
	azCompileOpt[elements] = "ENABLE_MEMSYS3";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_MEMSYS5)
	azCompileOpt[elements] = "ENABLE_MEMSYS5";
	elements++;
#endif
#if definedEx(SQLITE_ENABLE_OVERSIZE_CELL_CHECK)
	azCompileOpt[elements] = "ENABLE_OVERSIZE_CELL_CHECK";
	elements++;
#endif 
#if definedEx(SQLITE_ENABLE_UPDATE_DELETE_LIMIT)
	azCompileOpt[elements] = "ENABLE_UPDATE_DELETE_LIMIT";
	elements++;
#endif
#if definedEx(SQLITE_HAS_CODEC)
	azCompileOpt[elements] = "HAS_CODEC";
	elements++;
#endif
#if definedEx(SQLITE_HAVE_ISNAN)
	azCompileOpt[elements] = "HAVE_ISNAN";
	elements++;
#endif
#if definedEx(SQLITE_HOMEGROWN_RECURSIVE_MUTEX)
	azCompileOpt[elements] = "HOMEGROWN_RECURSIVE_MUTEX";
	elements++;
#endif  
	azCompileOpt[elements] = "MAX_MMAP_SIZE=" "0";
	elements++;
#if definedEx(SQLITE_NO_SYNC)
	azCompileOpt[elements] = "NO_SYNC";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_ANALYZE)
	azCompileOpt[elements] = "OMIT_ANALYZE";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_ATTACH)
	azCompileOpt[elements] = "OMIT_ATTACH";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_AUTOVACUUM)
	azCompileOpt[elements] = "OMIT_AUTOVACUUM";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_BLOB_LITERAL)
	azCompileOpt[elements] = "OMIT_BLOB_LITERAL";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_BUILTIN_TEST)
	azCompileOpt[elements] = "OMIT_BUILTIN_TEST";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_CAST)
	azCompileOpt[elements] = "OMIT_CAST";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_DECLTYPE)
	azCompileOpt[elements] = "OMIT_DECLTYPE";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_DEPRECATED)
	azCompileOpt[elements] = "OMIT_DEPRECATED";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_EXPLAIN)
	azCompileOpt[elements] = "OMIT_EXPLAIN";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_FOREIGN_KEY)
	azCompileOpt[elements] = "OMIT_FOREIGN_KEY";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_LOAD_EXTENSION)
	azCompileOpt[elements] = "OMIT_LOAD_EXTENSION";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_OR_OPTIMIZATION)
	azCompileOpt[elements] = "OMIT_OR_OPTIMIZATION";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_PAGER_PRAGMAS)
	azCompileOpt[elements] = "OMIT_PAGER_PRAGMAS";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_PRAGMA)
	azCompileOpt[elements] = "OMIT_PRAGMA";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_SUBQUERY)
	azCompileOpt[elements] = "OMIT_SUBQUERY";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_VACUUM)
	azCompileOpt[elements] = "OMIT_VACUUM";
	elements++;
#endif
#if definedEx(SQLITE_OMIT_VIEW)
	azCompileOpt[elements] = "OMIT_VIEW";
	elements++;
#endif
#if definedEx(SQLITE_RTREE_INT_ONLY)
	azCompileOpt[elements] = "RTREE_INT_ONLY";
	elements++;
#endif
#if definedEx(SQLITE_SMALL_STACK)
	azCompileOpt[elements] = "SMALL_STACK";
	elements++;
#endif  
	azCompileOpt[elements] = "THREADSAFE=" "1";
	elements++;

	// decrease size to actually needed
	azCompileOpt = (char**) realloc(azCompileOpt, (elements) * sizeof(char *));
}
