struct  ifdef_options {
  int config_feature_seamless_bz2 ;
  int config_pkill ;
  int config_tar ;
  int sqlite_omit_cast ;
  int sqlite_omit_blob_literal ;
  int sqlite_omit_pragma ;
  int sqlite_small_stack ;
  int config_feature_tar_gnu_extensions ;
  int sqlite_enable_cerod ;
  int config_selinux ;
  int sqlite_omit_builtin_test ;
  int config_feature_seamless_lzma ;
  int sqlite_enable_memsys3 ;
  int sqlite_enable_update_delete_limit ;
  int config_feature_ar_create ;
  int sqlite_enable_fts4 ;
  int sqlite_enable_memory_management ;
  int config_nommu ;
  int sqlite_omit_attach ;
  int config_feature_seamless_z ;
  int vdbe_profile ;
  int config_feature_run_parts_long_options ;
  int config_feature_ls_color_is_default ;
  int config_feature_ls_sortfiles ;
  int sqlite_malloc_soft_limit ;
  int config_feature_ls_recursive ;
  int config_test ;
  int config_cpio ;
  int config_feature_ls_followlinks ;
  int config_use_bb_pwd_grp ;
  int config_feature_expand_long_options ;
  int config_unicode_using_locale ;
  int config_unxz ;
  int _win32 ;
  int config_feature_shared_busybox ;
  int config_feature_hwib ;
  int config_feature_editing_savehistory ;
  int config_feature_individual ;
  int sqlite_rtree_int_only ;
  int config_feature_clean_up ;
  int config_use_bb_crypt ;
  int sqlite_omit_vacuum ;
  int config_feature_editing_vi ;
  int config_echo ;
  int config_feature_check_names ;
  int sqlite_omit_deprecated ;
  int config_feature_cpio_o ;
  int config_printf ;
  int config_unlzma ;
  int fdatasync ;
  int config_feature_topmem ;
  int sqlite_enable_sqllog ;
  int config_feature_tar_long_options ;
  int config_feature_seamless_xz ;
  int config_feature_fancy_head ;
  int config_lzma ;
  int config_feature_ls_filetypes ;
  int sqlite_omit_subquery ;
  int no_gettod ;
  int sqlite_omit_decltype ;
  int use_pread ;
  int config_feature_seamless_gz ;
  int config_feature_ps_additional_columns ;
  int config_feature_diff_long_options ;
  int config_pidof ;
  int config_unicode_support ;
  int config_feature_autowidth ;
  int config_install_no_usr ;
  int config_feature_shadowpasswds ;
  int config_dpkg ;
  int sqlite_enable_memsys5 ;
  int sqlite_omit_analyze ;
  int sqlite_default_memstatus ;
  int sqlite_omit_load_extension ;
  int sqlite_omit_or_optimization ;
  int use_pread64 ;
  int _win32_wce ;
  int sqlite_enable_column_metadata ;
  int config_ftpd ;
  int sqlite_homegrown_recursive_mutex ;
  int config_feature_gzip_long_options ;
  int config_feature_tar_to_command ;
  int config_feature_install_long_options ;
  int config_kill ;
  int _xopen_source ;
  int config_feature_utmp ;
  int config_feature_cpio_p ;
  int config_feature_username_completion ;
  int config_include_susv2 ;
  int config_feature_mkdir_long_options ;
  int config_gunzip ;
  int sqlite_enable_tree_explain ;
  int have_strerror_r ;
  int config_feature_ls_username ;
  int config_lfs ;
  int config_feature_del_user_from_group ;
  int _m_ix86 ;
  int config_feature_addgroup_long_options ;
  int sqlite_enable_oversize_cell_check ;
  int sqlite_enable_iotrace ;
  int config_feature_tar_uname_gname ;
  int config_bunzip2 ;
  int config_feature_pidfile ;
  int config_pmap ;
  int sqlite_coverage_test ;
  int sqlite_mutex_noop ;
  int win32 ;
  int _wrs_kernel ;
  int config_feature_adduser_to_group ;
  int config_feature_tab_completion ;
  int sqlite_have_isnan ;
  int sqlite_enable_fts4_unicode61 ;
  int sqlite_enable_expensive_assert ;
  int sqlite_enable_locking_style ;
  int config_xz ;
  int config_feature_ipv6 ;
  int sqlite_omit_autovacuum ;
  int config_killall ;
  int config_feature_check_unicode_in_env ;
  int config_feature_rmdir_long_options ;
  int _bsd_source ;
  int config_chown ;
  int config_ls ;
  int sqlite_omit_view ;
  int config_long_opts ;
  int config_ioctl_hex2str_error ;
  int config_feature_tar_selinux ;
  int sqlite_omit_explain ;
  int __i386__ ;
  int config_route ;
  int config_feature_mv_long_options ;
  int config_feature_prefer_applets ;
  int config_feature_unexpand_long_options ;
  int config_feature_ls_timestamps ;
  int config_locale_support ;
  int config_feature_start_stop_daemon_long_options ;
  int __rtp__ ;
  int config_desktop ;
  int sqlite_has_codec ;
  int config_dpkg_deb ;
  int config_feature_find_context ;
  int config_build_libbusybox ;
  int config_use_bb_shadow ;
  int sqlite_omit_foreign_key ;
  int have_stdint_h ;
  int config_pgrep ;
  int config_feature_adduser_long_options ;
  int config_feature_ls_color ;
  int sqlite_no_sync ;
  int sqlite_check_pages ;
  int config_feature_getopt_long ;
  int config_feature_env_long_options ;
  int config_feature_crond_d ;
  int config_rpm2cpio ;
  int sqlite_enable_fts3 ;
  int config_feature_human_readable ;
  int sqlite_omit_pager_pragmas ;
  int config_rpm ;
  int config_feature_show_threads ;
  int config_feature_syslog ;
  int config_uncompress ;
  int config_feature_top_smp_process ;
  int config_sestatus ;
  int sqlite_ebcdic ;
  int i386 ;
}  id2i;
extern struct  ifdef_options   id2i;
void id2i_init()  {
  (id2i.have_strerror_r = 0);
  (id2i.config_killall = 0);
  (id2i.config_feature_getopt_long = 0);
  (id2i.config_feature_gzip_long_options = 0);
  (id2i._wrs_kernel = 0);
  (id2i.vdbe_profile = 0);
  (id2i.config_feature_rmdir_long_options = 0);
  (id2i.sqlite_omit_subquery = 0);
  (id2i.config_feature_seamless_bz2 = 0);
  (id2i.config_feature_tab_completion = 0);
  (id2i.config_feature_expand_long_options = 0);
  (id2i.sqlite_omit_vacuum = 0);
  (id2i.config_feature_tar_uname_gname = 0);
  (id2i.config_nommu = 0);
  (id2i.sqlite_omit_decltype = 0);
  (id2i.config_locale_support = 0);
  (id2i.sqlite_enable_memory_management = 0);
  (id2i.sqlite_enable_iotrace = 0);
  (id2i.config_dpkg_deb = 0);
  (id2i.config_feature_username_completion = 0);
  (id2i.config_rpm2cpio = 0);
  (id2i.config_feature_ar_create = 0);
  (id2i.config_feature_ipv6 = 0);
  (id2i.sqlite_omit_load_extension = 1);
  (id2i.sqlite_have_isnan = 0);
  (id2i.config_feature_individual = 0);
  (id2i.have_stdint_h = 0);
  (id2i.config_feature_syslog = 0);
  (id2i.sqlite_omit_blob_literal = 1);
  (id2i.config_feature_shadowpasswds = 0);
  (id2i._win32 = 0);
  (id2i.config_feature_ls_recursive = 0);
  (id2i.sqlite_mutex_noop = 0);
  (id2i.config_feature_top_smp_process = 0);
  (id2i.config_feature_check_unicode_in_env = 0);
  (id2i.config_feature_ls_color_is_default = 0);
  (id2i.config_feature_tar_gnu_extensions = 0);
  (id2i.sqlite_enable_memsys5 = 0);
  (id2i.config_echo = 0);
  (id2i.config_pkill = 0);
  (id2i.config_feature_ls_sortfiles = 0);
  (id2i.sqlite_rtree_int_only = 0);
  (id2i.config_use_bb_crypt = 0);
  (id2i.config_feature_mv_long_options = 0);
  (id2i.config_feature_hwib = 0);
  (id2i.config_feature_autowidth = 0);
  (id2i._m_ix86 = 0);
  (id2i.config_unicode_using_locale = 0);
  (id2i._xopen_source = 0);
  (id2i.config_feature_ls_color = 0);
  (id2i.config_build_libbusybox = 0);
  (id2i.config_pgrep = 0);
  (id2i.config_feature_editing_vi = 0);
  (id2i.no_gettod = 0);
  (id2i.sqlite_enable_fts3 = 0);
  (id2i.config_feature_clean_up = 0);
  (id2i.config_feature_show_threads = 0);
  (id2i.sqlite_omit_attach = 0);
  (id2i.config_lzma = 0);
  (id2i.config_feature_env_long_options = 0);
  (id2i.sqlite_enable_fts4_unicode61 = 0);
  (id2i.config_pmap = 0);
  (id2i.config_printf = 0);
  (id2i.config_unxz = 0);
  (id2i.sqlite_omit_explain = 0);
  (id2i.config_gunzip = 0);
  (id2i.config_feature_adduser_to_group = 0);
  (id2i.sqlite_no_sync = 0);
  (id2i.config_feature_editing_savehistory = 0);
  (id2i.config_feature_shared_busybox = 0);
  (id2i.config_feature_start_stop_daemon_long_options = 0);
  (id2i.config_feature_mkdir_long_options = 0);
  (id2i.config_route = 0);
  (id2i.sqlite_malloc_soft_limit = 0);
  (id2i.config_unlzma = 0);
  (id2i.config_tar = 0);
  (id2i.config_sestatus = 0);
  (id2i.config_unicode_support = 0);
  (id2i.use_pread64 = 0);
  (id2i.i386 = 0);
  (id2i.config_feature_seamless_lzma = 0);
  (id2i.config_feature_diff_long_options = 0);
  (id2i.sqlite_enable_tree_explain = 0);
  (id2i.config_chown = 0);
  (id2i.config_feature_unexpand_long_options = 0);
  (id2i.sqlite_omit_pager_pragmas = 0);
  (id2i.config_kill = 0);
  (id2i.sqlite_enable_expensive_assert = 0);
  (id2i.sqlite_ebcdic = 0);
  (id2i.win32 = 0);
  (id2i.config_install_no_usr = 0);
  (id2i.config_feature_tar_long_options = 0);
  (id2i.config_feature_cpio_o = 0);
  (id2i.config_bunzip2 = 0);
  (id2i.config_feature_ps_additional_columns = 0);
  (id2i.sqlite_has_codec = 0);
  (id2i.config_feature_topmem = 0);
  (id2i.sqlite_omit_foreign_key = 0);
  (id2i.sqlite_enable_locking_style = 0);
  (id2i.config_use_bb_pwd_grp = 0);
  (id2i.config_feature_tar_selinux = 0);
  (id2i.sqlite_small_stack = 0);
  (id2i.config_feature_find_context = 0);
  (id2i.config_dpkg = 0);
  (id2i.fdatasync = 0);
  (id2i.sqlite_check_pages = 0);
  (id2i.sqlite_omit_cast = 0);
  (id2i.config_feature_check_names = 0);
  (id2i._bsd_source = 0);
  (id2i.__i386__ = 0);
  (id2i.config_feature_tar_to_command = 0);
  (id2i.config_feature_utmp = 0);
  (id2i.config_feature_seamless_xz = 0);
  (id2i.config_ls = 0);
  (id2i.config_cpio = 0);
  (id2i.sqlite_enable_memsys3 = 0);
  (id2i.config_desktop = 0);
  (id2i.config_xz = 0);
  (id2i.config_long_opts = 0);
  (id2i.sqlite_omit_autovacuum = 0);
  (id2i.sqlite_enable_cerod = 0);
  (id2i.config_feature_pidfile = 0);
  (id2i.config_uncompress = 0);
  (id2i.config_feature_ls_followlinks = 0);
  (id2i.sqlite_enable_oversize_cell_check = 0);
  (id2i.sqlite_enable_sqllog = 0);
  (id2i.config_feature_crond_d = 0);
  (id2i.config_feature_prefer_applets = 0);
  (id2i.sqlite_omit_builtin_test = 0);
  (id2i.config_feature_ls_timestamps = 0);
  (id2i.config_feature_del_user_from_group = 0);
  (id2i.config_feature_ls_filetypes = 0);
  (id2i.config_feature_install_long_options = 0);
  (id2i.config_ftpd = 0);
  (id2i.config_ioctl_hex2str_error = 0);
  (id2i.sqlite_omit_deprecated = 0);
  (id2i.config_rpm = 0);
  (id2i.config_feature_human_readable = 0);
  (id2i.config_feature_ls_username = 0);
  (id2i.sqlite_enable_fts4 = 0);
  (id2i.sqlite_homegrown_recursive_mutex = 0);
  (id2i.config_feature_seamless_gz = 0);
  (id2i.sqlite_enable_column_metadata = 0);
  (id2i.config_feature_cpio_p = 0);
  (id2i.sqlite_omit_view = 0);
  (id2i._win32_wce = 0);
  (id2i.config_test = 0);
  (id2i.config_feature_run_parts_long_options = 0);
  (id2i.sqlite_omit_analyze = 0);
  (id2i.sqlite_omit_pragma = 0);
  (id2i.config_feature_seamless_z = 0);
  (id2i.config_feature_adduser_long_options = 0);
  (id2i.config_include_susv2 = 0);
  (id2i.config_lfs = 0);
  (id2i.sqlite_omit_or_optimization = 0);
  (id2i.config_selinux = 0);
  (id2i.sqlite_default_memstatus = 1);
  (id2i.config_feature_fancy_head = 0);
  (id2i.use_pread = 0);
  (id2i.sqlite_coverage_test = 0);
  (id2i.__rtp__ = 0);
  (id2i.config_use_bb_shadow = 0);
  (id2i.config_feature_addgroup_long_options = 0);
  (id2i.sqlite_enable_update_delete_limit = 0);
  (id2i.config_pidof = 0);
}
