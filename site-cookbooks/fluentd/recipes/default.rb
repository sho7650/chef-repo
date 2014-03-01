#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
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

include_recipe "fluentd::client"
