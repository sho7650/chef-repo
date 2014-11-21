#
# Cookbook Name:: s3cmd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "s3cmd" do
  action :install
end

template "s3cfg" do
  path  "/root/.s3cfg"
  owner "root"
  group "root"
  mode  0600
end
