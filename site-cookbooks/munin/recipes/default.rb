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

