#
# Cookbook Name:: fluentd
# Recipe:: client
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "fluentd"

%w{libxml2 libxslt1.1 libyaml-0-2 sgml-base xml-core td-agent}.each do |pkg|
  package pkg do
    action :install
  end
end

service "td-agent" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end
