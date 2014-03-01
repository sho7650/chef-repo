# 
# Cookbook Name:: fluentd
# Attribute:: default
#
# Copyright 2014, sho kisaragi
#
# All rights reserved - Do Not Redistribute
#

default['fluentd']['hard'] = "65535"
default['fluentd']['soft'] = "65535"

default['fluentd']['tcp_tw_recycle']        = "1"
default['fluentd']['tw_reuse']              = "1"
default['fluentd']['local_port_range_from'] = "10240"
default['fluentd']['local_port_range_to']   = "65535"
