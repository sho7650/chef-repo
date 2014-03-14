#
# Cookbook Name:: apache
# Recipe:: ssl
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
execute "a2enmod-ssl" do
  command "a2enmod ssl"
  action :run
  not_if "apache2ctl -M | egrep 'ssl_module'"
  notifies :reload, 'service[apache2]'
end
