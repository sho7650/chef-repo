#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

package "nginx" do
  action :install
end

service "nginx" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end

directory node[:nginx][:cache_dir] do
  owner "www-data"
  group "www-data"
  mode  0755
  action :create
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :reload, 'service[nginx]'
end
