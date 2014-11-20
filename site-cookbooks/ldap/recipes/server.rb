#
# Cookbook Name:: ldap
# Recipe:: server
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "ldap-utils" do
  action :install
end

%w{libltdl7 libodbc1 libperl5.14 libslp1 psmisc}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{slapd}.each do |pkg|
  package pkg do
    action :install
    response_file "#{pkg}.seed"
  end
end

service "slapd" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

%w{olcDbIndex olcAccess}.each do |file|
  execute "ldapmodify-#{file}" do
    command "ldapmodify -Y EXTERNAL -H ldapi:/// -f #{Chef::Config[:file_cache_path]}/#{file}.ldif"
    action :nothing
  end

  template file+".ldif" do
    path  "#{Chef::Config[:file_cache_path]}/#{file}.ldif"
    owner "root"
    group "root"
    mode  0640

    notifies :run, "execute[ldapmodify-#{file}]"
  end
end

%w{initOU}.each do |file|
  execute "ldapadd-#{file}" do
    command "ldapadd -f #{Chef::Config[:file_cache_path]}/#{file}.ldif -x -D #{node[:ldap][:rootdn]} -w #{node[:ldap][:rootpw]}"
    action :nothing
  end

  template file+".ldif" do
    path  "#{Chef::Config[:file_cache_path]}/#{file}.ldif"
    owner "root"
    group "root"
    mode  0640

    notifies :run, "execute[ldapadd-#{file}]"
  end
end


