#
# Cookbook Name:: munin
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "munin"

package "munin" do
  action :install
end

service "munin" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

item = data_bag_item('munin','default')

template "munin.conf" do
  path  "/etc/munin/munin.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :nodes => item['nodes']
             })
  notifies :restart, 'service[munin]'
end

template "nginx.conf" do
  path  "/etc/nginx/conf.d/munin.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[nginx]'
end
