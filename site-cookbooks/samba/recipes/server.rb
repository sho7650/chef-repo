#
# Cookbook Name:: samba
# Recipe:: samba
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "samba"

%w{samba samba-doc smbldap-tools}.each do|pkg|
  package pkg do
    action :install
  end
end

service "samba" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "smb.conf" do
  path  "/etc/samba/smb.conf"
  owner "root"
  group "root"
  mode 0644
  variables ({
               :workgroup  => node[:samba][:workgroup],
               :hostname   => node[:samba][:hostname],
               :interfaces => node[:samba][:interfaces],
               :passdb     => node[:samba][:passdb],
               :security   => node[:samba][:security]
             })
  notifies :restart, 'service[samba]'
end

execute "setup-smbldap-tools" do
  command "zcat /usr/share/doc/smbldap-tools/examples/smbldap.conf.gz > /etc/smbldap-tools/smbldap.conf ; cp /usr/share/doc/smbldap-tools/examples/smbldap_bind.conf /etc/smbldap-tools/smbldap_bind.conf"
  not_if { File.exists?("/etc/smbldap-tools/smbldap_bind.conf") }
end

