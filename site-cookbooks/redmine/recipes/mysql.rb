data_bag = Chef::EncryptedDataBagItem.load('password','redmine')
redmine_password = data_bag['password']

execute "create-redminedb" do
  command "mysql -uroot < #{Chef::Config[:file_cache_path]}/create-redminedb.sql"
  action  :nothing
end

template "database.sql" do
  path "#{Chef::Config[:file_cache_path]}/create-redminedb.sql"
  source "database.sql.erb"
  user  "mysql"
  group "mysql"
  mode  0600
  variables ({
               :database_name     => node[:redmine][:database][:name],
               :database_user     => node[:redmine][:database][:user],
               :database_from     => node[:redmine][:database][:from],
               :database_password => redmine_password
 })

  notifies :run, 'execute[create-redminedb]'
end

