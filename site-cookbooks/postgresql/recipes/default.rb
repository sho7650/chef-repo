#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "postgresql-9.1" do
  action :install
end

user "zabbix" do
  uid 1011
  home "/home/zabbix"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
end

group "zabbix" do
  gid 1011
  members ['zabbix']
  action :create
end

service "postgresql" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end

template "postgresql.conf" do
  path "/etc/postgresql/9.1/main/postgresql.conf"
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :reload, 'service[postgresql]'
end

template "pg_hba.conf" do
  path "/etc/postgresql/9.1/main/pg_hba.conf"
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :reload, 'service[postgresql]'
end

template "pg_ident.conf" do
  path "/etc/postgresql/9.1/main/pg_ident.conf"
  source "pg_ident.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :reload, 'service[postgresql]'
end


