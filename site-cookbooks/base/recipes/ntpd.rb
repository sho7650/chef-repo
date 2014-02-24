#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "update-ntpdate" do
  command "ntpdate #{node['base']['ntp-server']}"
  action :nothing
end

package "ntpdate" do
  action :install
  notifies :run, 'execute[update-ntpdate]', :immediately
end

package "ntp" do
	action :install
end

service "ntp" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
