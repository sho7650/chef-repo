#
# Cookbook Name:: router
# Recipe:: masquerade
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "router"

%w{iptables iptables-persistent}.each do |pkg|
  package pkg do
    action :install
  end
end

service "iptables-persistent" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "rules.v4" do
  path  "/etc/iptables/rules.v4"
  owner "root"
  group "root"
  mode  0640
  notifies :restart, 'service[iptables-persistent]'
end
