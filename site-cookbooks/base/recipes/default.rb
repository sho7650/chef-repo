#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Adding ja_JP.UTF-8 
include_recipe "base::locale"

# Setting date and time. ntpdate and starting ntpd
include_recipe "base::ntpd"

