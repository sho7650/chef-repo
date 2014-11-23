#
# Cookbook Name:: ldap
# Recipe:: user
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

accounts = data_bag('users')

accounts.each do |id|
  users = data_bag_item('users', id)

  template "#{users['uid']}-user.ldif" do
    source "user.ldif.erb"
    path   "#{Chef::Config[:file_cache_path]}/#{users['uid']}-user.ldif"
    owner  "root"
    group  "root"
    mode   0640
    variables ({
                 :u => users
               })
  end
end
