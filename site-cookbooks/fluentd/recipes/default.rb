#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

bash "nw_setting" do
  user "root"
  code <<-EOF
    echo 'net.ipv4.tcp_tw_recycle = #{node['fluentd']['tcp_tw_recycle']}' >> /etc/sysctl.conf
    echo 'net.ipv4.tcp_tw_reuse = #{node['fluentd']['tw_reuse']}' >> /etc/sysctl.conf
    echo 'net.ipv4.ip_local_port_range = #{node['fluentd']['local_port_range_from']} #{node['fluentd']['local_port_range_to']}' >> /etc/sysctl.conf
    /sbin/sysctl -p /etc/sysctl.conf
  EOF
  not_if "egrep '^net.ipv4.ip_local_port_range = ' /etc/sysctl.conf"
end

template "limits.conf" do
  path "/etc/security/limits.conf"
  source "limits.conf.erb"
  owner "root"
  group "root"
  mode  0644
  variables ({
               :soft => node[:fluentd][:soft],
               :hard => node[:fluentd][:hard]
             })
end

execute "adding-gpg-td" do
  command "curl -L http://packages.treasure-data.com/debian/RPM-GPG-KEY-td-agent | apt-key add -"
  not_if "apt-key list | egrep -q 'Treasure Data'"
end

template "treasure-data.list" do
  path "/etc/apt/sources.list.d/treasure-data.list"
  owner "root"
  group "root"
  mode  0644
  notifies :run, 'execute[apt-get-update]', :immediately
end

dpkg_package "libssl0.9.8" do
        source "#{Chef::Config[:file_cache_path]}/#{node[:fluentd][:libssl_file]}"
        action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:fluentd][:libssl_file]}" do
        source node[:fluentd][:libssl_url]
        not_if "dpkg -l | egrep -q 'libssl0.9.8'"
        mode 0644
        notifies :install, 'dpkg_package[libssl0.9.8]', :immediately
end

