# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server" do
  action :install
end

service "mysql" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end

directory node[:mysql][:datadir] do
  owner node[:mysql][:owner]
  group node[:mysql][:group]
  mode  0755
  action :create
end

execute "mysql_install_db" do
  command "mysql_install_db --datadir=#{node[:mysql][:datadir]} --user=#{node[:mysql][:owner]}"
  not_if  { File.exists?("#{node[:mysql][:datadir]}/mysql") }
  action  :run
end

node.override['mysql']['innodb_buffer_pool_size'] = ((node['memory']['total'][0..-3].to_i / 1024).to_f * 0.8).to_i.to_s + "MB"
node.override['mysql']['innodb_log_file_size']    = ((node['mysql']['innodb_log_files_in_group'].to_i * 256).to_f * 0.5).to_i.to_s + "MB"

template "my.cnf" do
  path  "/etc/mysql/my.cnf"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :character_set           => node[:mysql][:character_set],
               :storage_engine          => node[:mysql][:storage_engine],
               :datadir                 => node[:mysql][:datadir],
               :max_connections         => node[:mysql][:max_connections],
               :table_open_cache        => node[:mysql][:table_open_cache],
               :innodb_buffer_pool_size => node[:mysql][:innodb_buffer_pool_size],
               :innodb_log_file_size    => node[:mysql][:innodb_log_file_size]
             })
  notifies :restart, 'service[mysql]', :immediately
end 

template "debian.cnf" do
  path  "/etc/mysql/debian.cnf"
  owner "root"
  group "root"
  mode  0600
  variables ({
               :sys_maint_password => node[:mysql][:sys_maint_password]
             })
  notifies :restart, 'service[mysql]'
end 

execute "mysql-chpasswd" do
  command "mysql -uroot < #{Chef::Config[:file_cache_path]}/my_chpasswd.sql"
  action  :nothing
end

template "my_chpasswd.sql" do
  path "#{Chef::Config[:file_cache_path]}/my_chpasswd.sql"
  source "my_chpasswd.sql.erb"
  user  "mysql"
  group "mysql"
  mode  0600
  variables ({
    :sys_maint_password => node[:mysql][:sys_maint_password]
 })

  notifies :run, 'execute[mysql-chpasswd]'
end
