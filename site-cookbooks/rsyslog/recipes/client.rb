#
# Cookbook Name:: rsyslog
# Recipe:: client
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rsyslog"

template "remote.conf" do
  path  "/etc/rsyslog.d/remote.conf"
  owner "root"
  group "root"
  mode  0640
  notifies :restart, 'service[rsyslog]'
end
