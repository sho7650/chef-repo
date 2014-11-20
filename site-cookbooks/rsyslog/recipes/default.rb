#
# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "rsyslog" do
  action :install
end

service "rsyslog" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

