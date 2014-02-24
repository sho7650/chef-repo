#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "apache2-mpm-prefork" do
  action :install
end

service "apache2" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
