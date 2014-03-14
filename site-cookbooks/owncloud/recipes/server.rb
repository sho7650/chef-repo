#
# Cookbook Name:: owncloud
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "owncloud"

execute "a2enmod-ssl" do
  command "a2enmod ssl"
  action :run
  not_if "apache2ctl -M | egrep 'ssl_module'"
  notifies :reload, 'service[apache2]'
end

execute "a2ensite-ssl" do
  command "a2ensite default-ssl"
  action :run
  not_if { File.exists?("/etc/apache2/sites-enabled/default-ssl") }
  notifies :reload, 'service[apache2]'
end

template "oshiire.key" do
  path  "/etc/ssl/private/oshiire.key"
  owner "root"
  group "ssl-cert"
  mode  0640
end

template "owncloud.crt" do
  path "/etc/ssl/certs/owncloud.crt"
  owner "root"
  group "root"
  mode  0644
end

template "default-ssl" do
  path  "/etc/apache2/sites-available/default-ssl"
  owner "root"
  group "root"
  mode  0644
  notifies :reload, 'service[apache2]'
end

package "owncloud" do
  action :install
end
