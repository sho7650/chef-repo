#
# Cookbook Name:: apache
# Recipe:: worker
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "apache2-mpm-worker" do
  action :install
end

service "apache2" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
