#
# Cookbook Name:: owncloud
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "owncloud"

template node[:ssl_value][:private_key_file] do
  path  "/etc/ssl/private/#{node[:ssl_value][:private_key_file]}"
  owner "root"
  group "ssl-cert"
  mode  0640
end

template node[:ssl_value][:server_crt_file] do
  path "/etc/ssl/certs/#{node[:ssl_value][:server_crt_file]}"
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

execute "a2ensite-ssl" do
  command "a2ensite default-ssl"
  action :run
  not_if { File.exists?("/etc/apache2/sites-enabled/default-ssl") }
  notifies :reload, 'service[apache2]'
end

package "owncloud" do
  action :install
end
