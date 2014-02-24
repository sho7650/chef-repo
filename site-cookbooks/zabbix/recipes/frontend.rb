#
# Cookbook Name:: zabbix
# Recipe:: frontend
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "zabbix::default"

package "zabbix-frontend-php" do
  action :install
  notifies :restart, 'service[apache2]'
end

template "apache.conf" do
  path  "/etc/zabbix/apache.conf"
  owner "root"
  group "root"
  mode   0644
  notifies :restart, 'service[apache2]'
end

template "zabbix.conf.php" do
  path  "/etc/zabbix/web/zabbix.conf.php"
  owner "www-data"
  group "www-data"
  mode  0644
  variables ({
    :TYPE         => node[:zabbix][:database][:type],
    :SERVER       => node[:zabbix][:database][:server],
    :PORT         => node[:zabbix][:database][:port],
    :DATABASE     => node[:zabbix][:database][:name],
    :USER         => node[:zabbix][:database][:user],
    :PASSWORD     => node[:zabbix][:database][:password],
    :ZBX_SVR      => node[:zabbix][:server],
    :ZBX_SVR_PORT => node[:zabbix][:port],
    :ZBX_SVR_NAME => node[:zabbix][:name]
  })
end
