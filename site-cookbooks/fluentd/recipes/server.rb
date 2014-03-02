#
# Cookbook Name:: fluentd
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "fluentd"

package "td-agent" do
  action :install
end

service "td-agent" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end
