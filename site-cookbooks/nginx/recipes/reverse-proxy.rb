#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

template "reverse_proxy.conf" do
  path "/etc/nginx/conf.d/reverse_proxy.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :listen_port => node[:nginx][:reverse][:listen_port],
               :server_name => node[:nginx][:reverse][:server_name],
               :proxy_url   => node[:nginx][:reverse][:proxy_url]
             })
  notifies :reload, 'service[nginx]'
end
