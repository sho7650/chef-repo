#
# Cookbook Name:: munin
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "munin-node" do
  action :install
end

service "munin-node" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "munin-node.conf" do
  path  "/etc/munin/munin-node.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[munin-node]'
end
