# -*- coding: utf-8 -*-
#
# Cookbook Name:: iscsi
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

package "open-iscsi" do
  action :install
end

template "open-iscsi" do
  path  "/etc/default/open-iscsi"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :vg_name => node[:lvm][:vg_name]
             })
end

bash "fstab" do
  user "root"
  code "echo '/dev/#{node['lvm']['vg_name']}/#{node['lvm']['lv_name']} #{node['lvm']['mount_point']} #{node['lvm']['lv_name']}    defaults,noatime,nodiratime,_netdev     0       0' >> /etc/fstab"
  not_if "egrep '#{node['lvm']['lv_name']} /etc/fstab"
end
