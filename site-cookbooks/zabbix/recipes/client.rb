#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "zabbix-agent" do
	action :install
end

service "zabbix-agent" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "zabbix_agentd.conf" do
  path "/etc/zabbix/zabbix_agentd.conf"
  user "root"
  group "root"
  mode 0644
  variables ({
               :hostname => node[:hostname],
               :server   => node[:zabbix][:server]
             })
  notifies :restart, 'service[zabbix-agent]'
end
