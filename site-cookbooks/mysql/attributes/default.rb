# Cookbook Name:: mysql
# Attribute:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

default['mysql']['sys_maint_password'] = "cow9quarj8ur3o"
default['mysql']['owner']              = "mysql"
default['mysql']['group']              = "mysql"

# default['mysql']['datadir']            = "/var/lib/mysql"
default['mysql']['datadir']            = "/home/mysql"
default['mysql']['character_set']      = "utf8"
default['mysql']['storage_engine']     = "InnoDB"

default['mysql']['innodb_buffer_pool_size']   = "512MB"
default['mysql']['innodb_log_file_size']      = "256MB"
default['mysql']['innodb_log_files_in_group'] = "2"

default['mysql']['table_open_cache']          = "1024"
