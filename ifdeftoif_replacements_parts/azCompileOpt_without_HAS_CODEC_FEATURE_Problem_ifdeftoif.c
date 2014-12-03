struct  ifdef_options {
  int sqlite_rtree_int_only ;
  int sqlite_omit_vacuum ;
  int sqlite_omit_blob_literal ;
  int sqlite_omit_pager_pragmas ;
  int sqlite_omit_pragma ;
  int sqlite_omit_or_optimization ;
  int sqlite_enable_column_metadata ;
  int sqlite_omit_decltype ;
  int sqlite_enable_fts3 ;
  int sqlite_omit_builtin_test ;
  int sqlite_enable_memsys5 ;
  int sqlite_enable_expensive_assert ;
  int sqlite_have_isnan ;
  int sqlite_omit_attach ;
  int sqlite_enable_memsys3 ;
  int sqlite_omit_analyze ;
  int sqlite_check_pages ;
  int sqlite_omit_deprecated ;
  int sqlite_omit_autovacuum ;
  int sqlite_enable_fts4 ;
  int sqlite_omit_load_extension ;
  int sqlite_enable_oversize_cell_check ;
  int sqlite_enable_locking_style ;
  int sqlite_coverage_test ;
  int sqlite_enable_cerod ;
  int sqlite_omit_explain ;
  int sqlite_enable_memory_management ;
  int sqlite_omit_cast ;
  int sqlite_enable_iotrace ;
  int sqlite_omit_view ;
  int sqlite_omit_foreign_key ;
  int sqlite_homegrown_recursive_mutex ;
  int sqlite_no_sync ;
  int sqlite_small_stack ;
  int sqlite_omit_subquery ;
  int sqlite_enable_update_delete_limit ;
}  id2i;
void id2i_init()  {
  (id2i.sqlite_check_pages = 0);
  (id2i.sqlite_omit_vacuum = 0);
  (id2i.sqlite_omit_decltype = 0);
  (id2i.sqlite_omit_subquery = 0);
  (id2i.sqlite_omit_attach = 0);
  (id2i.sqlite_enable_column_metadata = 0);
  (id2i.sqlite_enable_expensive_assert = 0);
  (id2i.sqlite_omit_view = 0);
  (id2i.sqlite_omit_analyze = 0);
  (id2i.sqlite_enable_locking_style = 0);
  (id2i.sqlite_coverage_test = 0);
  (id2i.sqlite_rtree_int_only = 0);
  (id2i.sqlite_enable_memsys5 = 0);
  (id2i.sqlite_enable_fts4 = 0);
  (id2i.sqlite_enable_memory_management = 0);
  (id2i.sqlite_homegrown_recursive_mutex = 0);
  (id2i.sqlite_omit_cast = 0);
  (id2i.sqlite_omit_or_optimization = 0);
  (id2i.sqlite_enable_memsys3 = 0);
  (id2i.sqlite_omit_builtin_test = 0);
  (id2i.sqlite_enable_fts3 = 0);
  (id2i.sqlite_enable_update_delete_limit = 0);
  (id2i.sqlite_omit_explain = 0);
  (id2i.sqlite_have_isnan = 0);
  (id2i.sqlite_omit_foreign_key = 0);
  (id2i.sqlite_enable_oversize_cell_check = 0);
  (id2i.sqlite_omit_deprecated = 0);
  (id2i.sqlite_omit_load_extension = 0);
  (id2i.sqlite_small_stack = 0);
  (id2i.sqlite_omit_blob_literal = 0);
  (id2i.sqlite_enable_iotrace = 0);
  (id2i.sqlite_enable_cerod = 0);
  (id2i.sqlite_omit_pager_pragmas = 0);
  (id2i.sqlite_no_sync = 0);
  (id2i.sqlite_omit_pragma = 0);
  (id2i.sqlite_omit_autovacuum = 0);
}
char **azCompileOpt;
void init_azCompileOpt()  {
  int elements =  0;
  (azCompileOpt = ((char **) malloc((38 * sizeof(char *)))));
  if (id2i.sqlite_check_pages) {
    (azCompileOpt[elements] = CHECK_PAGES);
  }  
  if (id2i.sqlite_check_pages) {
    elements++;
  }  
  if (id2i.sqlite_coverage_test) {
    (azCompileOpt[elements] = COVERAGE_TEST);
  }  
  if (id2i.sqlite_coverage_test) {
    elements++;
  }  
  if (id2i.sqlite_enable_cerod) {
    (azCompileOpt[elements] = ENABLE_CEROD);
  }  
  if (id2i.sqlite_enable_cerod) {
    elements++;
  }  
  if (id2i.sqlite_enable_column_metadata) {
    (azCompileOpt[elements] = ENABLE_COLUMN_METADATA);
  }  
  if (id2i.sqlite_enable_column_metadata) {
    elements++;
  }  
  if (id2i.sqlite_enable_expensive_assert) {
    (azCompileOpt[elements] = ENABLE_EXPENSIVE_ASSERT);
  }  
  if (id2i.sqlite_enable_expensive_assert) {
    elements++;
  }  
  if ((id2i.sqlite_enable_fts4 || id2i.sqlite_enable_fts3)) {
    (azCompileOpt[elements] = ENABLE_FTS3);
  }  
  if ((id2i.sqlite_enable_fts4 || id2i.sqlite_enable_fts3)) {
    elements++;
  }  
  if (id2i.sqlite_enable_fts4) {
    (azCompileOpt[elements] = ENABLE_FTS4);
  }  
  if (id2i.sqlite_enable_fts4) {
    elements++;
  }  
  if (id2i.sqlite_enable_iotrace) {
    (azCompileOpt[elements] = ENABLE_IOTRACE);
  }  
  if (id2i.sqlite_enable_iotrace) {
    elements++;
  }  
  if (id2i.sqlite_enable_locking_style) {
    (azCompileOpt[elements] = ENABLE_LOCKING_STYLE=SQLITE_ENABLE_LOCKING_STYLE);
  }  
  if (id2i.sqlite_enable_locking_style) {
    elements++;
  }  
  if (id2i.sqlite_enable_memory_management) {
    (azCompileOpt[elements] = ENABLE_MEMORY_MANAGEMENT);
  }  
  if (id2i.sqlite_enable_memory_management) {
    elements++;
  }  
  if (id2i.sqlite_enable_memsys3) {
    (azCompileOpt[elements] = ENABLE_MEMSYS3);
  }  
  if (id2i.sqlite_enable_memsys3) {
    elements++;
  }  
  if (id2i.sqlite_enable_memsys5) {
    (azCompileOpt[elements] = ENABLE_MEMSYS5);
  }  
  if (id2i.sqlite_enable_memsys5) {
    elements++;
  }  
  if (id2i.sqlite_enable_oversize_cell_check) {
    (azCompileOpt[elements] = ENABLE_OVERSIZE_CELL_CHECK);
  }  
  if (id2i.sqlite_enable_oversize_cell_check) {
    elements++;
  }  
  if (id2i.sqlite_enable_update_delete_limit) {
    (azCompileOpt[elements] = ENABLE_UPDATE_DELETE_LIMIT);
  }  
  if (id2i.sqlite_enable_update_delete_limit) {
    elements++;
  }  
  if (id2i.sqlite_have_isnan) {
    (azCompileOpt[elements] = HAVE_ISNAN);
  }  
  if (id2i.sqlite_have_isnan) {
    elements++;
  }  
  if (id2i.sqlite_homegrown_recursive_mutex) {
    (azCompileOpt[elements] = HOMEGROWN_RECURSIVE_MUTEX);
  }  
  if (id2i.sqlite_homegrown_recursive_mutex) {
    elements++;
  }  
  (azCompileOpt[elements] = MAX_MMAP_SIZE= 0);
  elements++;
  if (id2i.sqlite_no_sync) {
    (azCompileOpt[elements] = NO_SYNC);
  }  
  if (id2i.sqlite_no_sync) {
    elements++;
  }  
  if (id2i.sqlite_omit_analyze) {
    (azCompileOpt[elements] = OMIT_ANALYZE);
  }  
  if (id2i.sqlite_omit_analyze) {
    elements++;
  }  
  if (id2i.sqlite_omit_attach) {
    (azCompileOpt[elements] = OMIT_ATTACH);
  }  
  if (id2i.sqlite_omit_attach) {
    elements++;
  }  
  if (id2i.sqlite_omit_autovacuum) {
    (azCompileOpt[elements] = OMIT_AUTOVACUUM);
  }  
  if (id2i.sqlite_omit_autovacuum) {
    elements++;
  }  
  if (id2i.sqlite_omit_blob_literal) {
    (azCompileOpt[elements] = OMIT_BLOB_LITERAL);
  }  
  if (id2i.sqlite_omit_blob_literal) {
    elements++;
  }  
  if (id2i.sqlite_omit_builtin_test) {
    (azCompileOpt[elements] = OMIT_BUILTIN_TEST);
  }  
  if (id2i.sqlite_omit_builtin_test) {
    elements++;
  }  
  if (id2i.sqlite_omit_cast) {
    (azCompileOpt[elements] = OMIT_CAST);
  }  
  if (id2i.sqlite_omit_cast) {
    elements++;
  }  
  if (id2i.sqlite_omit_decltype) {
    (azCompileOpt[elements] = OMIT_DECLTYPE);
  }  
  if (id2i.sqlite_omit_decltype) {
    elements++;
  }  
  if (id2i.sqlite_omit_deprecated) {
    (azCompileOpt[elements] = OMIT_DEPRECATED);
  }  
  if (id2i.sqlite_omit_deprecated) {
    elements++;
  }  
  if (id2i.sqlite_omit_explain) {
    (azCompileOpt[elements] = OMIT_EXPLAIN);
  }  
  if (id2i.sqlite_omit_explain) {
    elements++;
  }  
  if (id2i.sqlite_omit_foreign_key) {
    (azCompileOpt[elements] = OMIT_FOREIGN_KEY);
  }  
  if (id2i.sqlite_omit_foreign_key) {
    elements++;
  }  
  if (id2i.sqlite_omit_load_extension) {
    (azCompileOpt[elements] = OMIT_LOAD_EXTENSION);
  }  
  if (id2i.sqlite_omit_load_extension) {
    elements++;
  }  
  if (id2i.sqlite_omit_or_optimization) {
    (azCompileOpt[elements] = OMIT_OR_OPTIMIZATION);
  }  
  if (id2i.sqlite_omit_or_optimization) {
    elements++;
  }  
  if (id2i.sqlite_omit_pager_pragmas) {
    (azCompileOpt[elements] = OMIT_PAGER_PRAGMAS);
  }  
  if (id2i.sqlite_omit_pager_pragmas) {
    elements++;
  }  
  if (id2i.sqlite_omit_pragma) {
    (azCompileOpt[elements] = OMIT_PRAGMA);
  }  
  if (id2i.sqlite_omit_pragma) {
    elements++;
  }  
  if (id2i.sqlite_omit_subquery) {
    (azCompileOpt[elements] = OMIT_SUBQUERY);
  }  
  if (id2i.sqlite_omit_subquery) {
    elements++;
  }  
  if (id2i.sqlite_omit_vacuum) {
    (azCompileOpt[elements] = OMIT_VACUUM);
  }  
  if (id2i.sqlite_omit_vacuum) {
    elements++;
  }  
  if (id2i.sqlite_omit_view) {
    (azCompileOpt[elements] = OMIT_VIEW);
  }  
  if (id2i.sqlite_omit_view) {
    elements++;
  }  
  if (id2i.sqlite_rtree_int_only) {
    (azCompileOpt[elements] = RTREE_INT_ONLY);
  }  
  if (id2i.sqlite_rtree_int_only) {
    elements++;
  }  
  if (id2i.sqlite_small_stack) {
    (azCompileOpt[elements] = SMALL_STACK);
  }  
  if (id2i.sqlite_small_stack) {
    elements++;
  }  
  (azCompileOpt[elements] = THREADSAFE= 1);
  elements++;
  (azCompileOpt = ((char **) realloc(azCompileOpt, (elements * sizeof(char *)))));
}