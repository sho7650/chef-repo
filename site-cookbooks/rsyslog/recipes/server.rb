#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rsyslog"

template "rsyslog.conf" do
  path  "/etc/rsyslog.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[rsyslog]'
end

template "collection.conf" do
  path  "/etc/rsyslog.d/collection.conf"
  owner "root"
  group "root"
  mode  0640
  notifies :restart, 'service[rsyslog]'
end
