#
# Cookbook Name:: owncloud
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
execute "adding-gpg-oc" do
  command "curl -L http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key | apt-key add -"
  not_if "apt-key list | egrep -q 'ownCloud'"
end


template "owncloud.list" do
  path  "/etc/apt/sources.list.d/owncloud.list"
  owner "root"
  group "root"
  mode  0644
  notifies :run, 'execute[apt-get-update]', :immediately
end
