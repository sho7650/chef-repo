#
# Cookbook Name:: ldap
# Recipe:: samba
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "samba-doc" do
  action :install
end

execute "install-samba.schema" do
  command "zcat /usr/share/doc/samba-doc/examples/LDAP/samba.schema.gz > /etc/ldap/schema/samba.schema"
  not_if  { File.exists?("/etc/ldap/schema/samba.schema") }
end

execute "install-samba.ldif" do
  command "slaptest -f #{Chef::Config[:file_cache_path]}/samba.conf -F /etc/ldap/slapd.d/"
  user    "openldap"
  group   "openldap"
  action :nothing
  notifies :restart, 'service[slapd]'
end

template "samba.conf" do
  path  "#{Chef::Config[:file_cache_path]}/samba.conf"
  owner "openldap"
  group "openldap"
  mode  0644
  notifies :run, 'execute[install-samba.ldif]', :immediately
end


