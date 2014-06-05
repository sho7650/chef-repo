# Cookbook Name:: mysql
# Attribute:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

default['mysql']['owner']              = "mysql"
default['mysql']['group']              = "mysql"

# default['mysql']['datadir']            = "/var/lib/mysql"
# default['mysql']['datadir']            = "/home/mysql"
default['mysql']['datadir']            = "/var/lib/store01"
default['mysql']['character_set']      = "utf8"
default['mysql']['storage_engine']     = "InnoDB"

default['mysql']['max_connections']           = "31"
default['mysql']['innodb_buffer_pool_size']   = "512MB"
default['mysql']['innodb_log_file_size']      = "256MB"
default['mysql']['innodb_log_files_in_group'] = "2"
default['mysql']['innodb_data_file_size']     = "1G"
default['mysql']['innodb_file_format']        = "Barracuda"

default['mysql']['table_open_cache']          = "1024"
