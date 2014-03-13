#
# Cookbook Name:: owncloud
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
include_recipe "owncloud"

package "owncloud" do
  action :install
end
