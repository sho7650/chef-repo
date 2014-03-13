#
# Cookbook Name:: nginx
# Recipe:: php5
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

package "php5-fpm" do
  action :install
end

service "php5-fpm" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
