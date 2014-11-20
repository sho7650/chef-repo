#
# Cookbook Name:: ldap
# Recipe:: user
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#

accounts = data_bag('users')

accounts.each do |id|
  item = data_bag_item('users', id)


  item['groups'].each do |g|
    if system("getent group | egrep -q #{g['name']}") then
      opt = ""
    else
      opt = "-a"
    end

    execute "ldapgroup-#{g['name']}-#{g['member']}" do
      command "ldapmodify #{opt} -f #{Chef::Config[:file_cache_path]}/#{g['name']}-#{g['member']}-group.ldif -x -D #{node[:ldap][:rootdn]} -w #{node[:ldap][:rootpw]}"
      action :nothing
    end

    template g['name']+"-"+g['member']+"-group.ldif" do
      source "group#{opt}.ldif.erb"
      path   "#{Chef::Config[:file_cache_path]}/#{g['name']}-#{g['member']}-group.ldif"
      owner  "root"
      group  "root"
      mode   0640

      variables ({
                   :ldapgroup  => g['name'],
                   :ldapgid    => g['gid'],
                   :ldapmember => g['member']
                 })

      not_if "getent group | egrep -q '^#{g['name']}' | egrep -q #{g['member']}"
      notifies :run, "execute[ldapgroup-#{g['name']}-#{g['member']}]", :immediately
    end
      
    
  end
end
