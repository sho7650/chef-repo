#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"

dpkg_package "zabbix-release" do
        source "#{Chef::Config[:file_cache_path]}/zabbix-release_2.2-1+wheezy_all.deb"
        action :nothing
        notifies :run, 'execute[apt-get-update]', :immediately
end

remote_file "#{Chef::Config[:file_cache_path]}/zabbix-release_2.2-1+wheezy_all.deb" do
        source "http://repo.zabbix.com/zabbix/2.2/debian/pool/main/z/zabbix-release/zabbix-release_2.2-1+wheezy_all.deb"
        not_if "dpkg -l | grep -q 'zabbix-release'"
        mode 0644
        notifies :install, 'dpkg_package[zabbix-release]', :immediately
end

include_recipe "zabbix::client"
