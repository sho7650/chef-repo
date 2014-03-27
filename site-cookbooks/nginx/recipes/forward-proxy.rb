#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

template "forward_proxy.conf" do
  path "/etc/nginx/conf.d/forward_proxy.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :cache_dir    => node[:nginx][:cache_dir],
               :listen_port  => node[:nginx][:forward][:listen_port],
               :server_name  => node[:nginx][:forward][:server_name],
               :resolver_ip  => node[:nginx][:forward][:resolver_ip]
             })
  notifies :reload, 'service[nginx]'
end
