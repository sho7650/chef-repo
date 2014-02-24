#
# Cookbook Name:: apache
# Recipe:: php5
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{php5-pgsql php5-mysql libapache2-mod-php5}.each do |pkg|
  package pkg do
    action :install
  end
end

template "php.ini" do
  path "/etc/php5/apache2/php.ini"
  user "root"
  group "root"
  mode 0644
  variables(
    :max_execution_time  => node['php_value']['max_execution_time'],
    :memory_limit        => node['php_value']['memory_limit'],
    :post_max_size       => node['php_value']['post_max_size'],
    :upload_max_filesize => node['php_value']['upload_max_filesize'],
    :max_input_time      => node['php_value']['max_input_time'],
    :date_timezone       => node['php_value']['date.timezone']
  )

  notifies :restart, 'service[apache2]'
end

