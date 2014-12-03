#
# Cookbook Name:: munin
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "munin"

%w{munin spawn-fcgi}.each do |pkg|
  package pkg do
    action :install
  end
end

item = data_bag_item('munin',node.chef_environment)

template "munin.conf" do
  path  "/etc/munin/munin.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :nodes => item['nodes']
             })
end

execute "insserv-spawn-fcgi-munin" do
  command "insserv spawn-fcgi-munin"
  action :nothing
end

template "spawn-fcgi-munin" do
  path  "/etc/init.d/spawn-fcgi-munin"
  owner "root"
  group "root"
  mode  0750
  notifies :run, 'execute[insserv-spawn-fcgi-munin]'
end

service "spawn-fcgi-munin" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

%w{munin-cgi-html.log munin-cgi-graph.log}.each do |pkg|
  file pkg do
    path  "/var/log/munin/#{pkg}"
    owner "munin"
    group "adm"
    mode  0640
    action :create
    notifies :restart, 'service[spawn-fcgi-munin]'
  end
end

template "nginx.conf" do
  path  "/etc/nginx/conf.d/munin.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[nginx]'
end
