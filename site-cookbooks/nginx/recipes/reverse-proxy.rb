#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
servers = data_bag_item('proxylist','production')['servers']

template "reverse_proxy.conf" do
  path "/etc/nginx/conf.d/reverse_proxy.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :proxy_list => servers
             })
  notifies :reload, 'service[nginx]'
end

ssl_servers = data_bag_item('proxylist','ssl')['servers']

template "reverse_proxy_ssl.conf" do
  path "/etc/nginx/conf.d/reverse_proxy_ssl.conf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :sslproxy_list => ssl_servers
             })
  notifies :reload, 'service[nginx]'
end
