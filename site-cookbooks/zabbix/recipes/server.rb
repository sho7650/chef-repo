#
# Cookbook Name:: zabbix
# Recipe:: server
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "zabbix::default"

package "zabbix-server-pgsql" do
	action :install
end

service "zabbix-server" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "zabbix_server.conf" do
  path "/etc/zabbix/zabbix_server.conf"
  user "root"
  group "root"
  mode 0600
  variables ({
               :dbhost   => node[:zabbix][:host],
               :dbuser   => node[:zabbix][:user],
               :database => node[:zabbix][:database],
               :dbpasswd => node[:zabbix][:password]
             })

  notifies :restart, 'service[zabbix-server]'
end
	
