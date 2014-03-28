#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

# Adding ja_JP.UTF-8 
include_recipe "base::locale"

# Setting date and time. ntpdate and starting ntpd
include_recipe "base::ntpd"

# Disalbing ipv6
include_recipe "base::ipv6"
