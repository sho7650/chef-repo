# Cookbook Name:: ldap
# Recipe:: client
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

%w{libpam-ldap libnss-ldap}.each do |pkg|
  package pkg do
    action :install
  end
end

template "pam_ldap.conf" do
  path "/etc/pam_ldap.conf"
  owner "root"
  group "root"
  mode  0644
end

template "libnss-ldap.conf" do
  path "/etc/libnss-ldap.conf"
  owner "root"
  group "root"
  mode  0600
end

template "nsswitch.conf" do
  path "/etc/nsswitch.conf"
  owner "root"
  group "root"
  mode  0644
end

%w{common-password common-session}.each do |file|
  template file do
    path  "/etc/pam.d/#{file}"
    owner "root"
    group "root"
    mode  0644
  end
end
