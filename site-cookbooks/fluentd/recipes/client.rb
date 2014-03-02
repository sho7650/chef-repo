#
# Cookbook Name:: fluentd
# Recipe:: client
#
# Copyright 2014, YOUR_COMPANY_NAME
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
