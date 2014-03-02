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

# 'td-agent' will need the package of "libssl0.9.8"
default['fluentd']['libssl_url']  = "http://ftp.jp.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb"
default['fluentd']['libssl_file'] = File.basename(node['fluentd']['libssl_url'])
