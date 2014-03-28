#
# Cookbook Name:: base
# Recipe:: ipv6
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

execute "update-grub" do
  action :nothing
end

execute "rewrite-grub" do
  command 'sed -i s%^GRUB_CMDLINE_LINUX=\"%GRUB_CMDLINE_LINUX=\"ipv6.disable=1% /etc/default/grub'
  action :run
  not_if "egrep -q 'ipv6.disable=1' /etc/default/grub"
  notifies :run, 'execute[update-grub]'
end
