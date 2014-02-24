#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "locale-gen" do
	action :nothing
end

template "locale.gen" do
  path "/etc/locale.gen"
  source "locale.gen.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, "execute[locale-gen]"
end
