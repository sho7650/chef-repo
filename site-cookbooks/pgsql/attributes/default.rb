# 
# Cookbook Name:: pgsql
# Attribute:: default
#
# Copyright 2014, sho kisaragi
#
# All rights reserved - Do Not Redistribute
#

# users & passwords

default['postgresql']['user']                 = ""
default['postgresql']['password']             = ""

# Depends on hardware resource
default['postgresql']['max_connections']      = "100"
default['postgresql']['shared_buffers']       = "24MB"
default['postgresql']['maintenance_work_mem'] = "16MB"
default['postgresql']['work_mem']             = "1MB"
default['postgresql']['effective_cache_size'] = "128MB"
 
default['postgresql']['shmall']               = "2097152"
default['postgresql']['shmmax']               = "33554432"

