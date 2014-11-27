#
# Cookbook Name:: router
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
execute "sysctl" do
  command "sysctl -p"
  action :nothing
end


template "sysctl.conf" do
  path    "/etc/sysctl.conf"
  owner   "root"
  group   "root"
  mode    0640
  notifies :run, 'execute[sysctl]'
end
