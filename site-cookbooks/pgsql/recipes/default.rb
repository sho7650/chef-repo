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

# create a user with an MD5-encrypted password
# pg_user "zabbix" do
#   privileges superuser: false, createdb: false, login: true
#   encrypted_password "5fce1b3e34b520afeffb37ce08c7cd66"
# end

# create a database
# pg_database "zabbix" do
#   owner "zabbix"
#   encoding "utf8"
#   template "template0"
#   locale "ja_JP.UTF8"
# end

# SHMMAX in bytes
def shmmax
  (node['memory']['total'][0..-3].to_i * 1024)
end
 
# SHMMAX in pages
def shmall
  pages = (node['memory']['total'][0..-3].to_i * 1024) / 4096
  if pages < 2097152
    2097152
  else
    pages
  end
end
 
node.override["postgresql"]["max_connections"]                 = 250
node.override["postgresql"]["shared_buffers"]                  = ((node['memory']['total'][0..-3].to_i / 1024).to_f * 0.25).to_i.to_s + "MB"
node.override["postgresql"]["maintenance_work_mem"]            = ((node['memory']['total'][0..-3].to_i / 1024).to_f * 0.10).to_i.to_s + "MB"
node.override["postgresql"]["work_mem"]                        = (((node['memory']['total'][0..-3].to_i / 1024).to_f * 0.75)/node["postgresql"]["max_connections"].to_f).to_i.to_s + "MB"
node.override["postgresql"]["effective_cache_size"]            = ((node['memory']['total'][0..-3].to_i / 1024).to_f * 0.75).to_i.to_s + "MB"
 
node.override["postgresql"]["shmall"] = shmall
node.override["postgresql"]["shmmax"] = shmmax

log "max_connections = #{node["postgresql"]["max_connections"]}"
log "shared_buffers = #{node["postgresql"]["shared_buffers"]}"
 
bash "add shm settings" do
  user "root"
  code <<-EOF
    echo 'kernel.shmmax = #{node['postgresql']['shmmax']}' >> /etc/sysctl.conf
    echo 'kernel.shmall = #{node['postgresql']['shmall']}' >> /etc/sysctl.conf
    /sbin/sysctl -p /etc/sysctl.conf
  EOF
  not_if "egrep '^kernel.shmmax = ' /etc/sysctl.conf"
end

template "postgresql.conf" do
  path "/etc/postgresql/9.1/main/postgresql.conf"
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :restart, 'service[postgresql]'
end

template "pg_hba.conf" do
  path "/etc/postgresql/9.1/main/pg_hba.conf"
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :restart, 'service[postgresql]'
end

template "pg_ident.conf" do
  path "/etc/postgresql/9.1/main/pg_ident.conf"
  source "pg_ident.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0644
  notifies :restart, 'service[postgresql]'
end

