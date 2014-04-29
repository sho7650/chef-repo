#
# Cookbook Name:: ldap
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "ldap-utils" do
  action :install
end

%w{libltdl7 libodbc1 libperl5.14 libslp1 psmisc}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{slapd}.each do |pkg|
  package pkg do
    action :install
    response_file "#{pkg}.seed"
  end
end

service "slapd" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end
