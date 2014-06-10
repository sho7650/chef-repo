#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

filename      = "redmine-2.5.1.tar.gz"
dirname       = File.basename(filename,".tar.gz")
install_dir   = "/usr/share"
remote_uri    = "http://www.redmine.org/releases"
file_checksum = "1580396c030c1233e9acffcb97bf43b69fb3c04c6b00accbabf77d2a4a8c93f0"

%w{curl git imagemagick libmagickwand-dev libmysqlclient-dev apache2-threaded-dev libcurl4-gnutls-dev libreadline6-dev libssl-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison libffi-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "rvm" do
  action :install
end

# execute "install_rvm" do
#   command "curl -sSL https://get.rvm.io | sudo bash -s stable"
#   action :run
#   not_if { File.exists?("/usr/local/rvm/bin/rvm") }
# end

execute "install_ruby2" do
  command "rvm install 2.0.0"
  action :run
  not_if { File.exists?("/opt/chef/ruby") }
end

execute "extract_#{filename}" do
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{filename} -C #{install_dir}"
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source "#{remote_uri}/#{filename}"
  checksum "#{file_checksum}"
  notifies :run, "execute[extract_#{filename}]", :immediately
end

execute "install_#{filename}" do
  cwd "#{install_dir}/#{dirname}"
  command '/usr/local/rvm/gems/ruby-2.0.0-p481@global/bin/bundle install --without development test postgresql sqlite'
  action :nothing
end

directory "/usr/share/#{dirname}" do
  owner "www-data"
  group "www-data"
  recursive true
end

link "/var/www/redmine" do
  owner "www-data"
  group "www-data"
  to    "/usr/share/#{dirname}"
  notifies :run, "execute[install_#{filename}]", :immediately
end

execute "createdb" do
  cwd "#{install_dir}/#{dirname}"
  command <<-EOL
    /usr/local/rvm/rubies/ruby-2.0.0-p481/bin/rake generate_secret_token
    RAILS_ENV=production /usr/local/rvm/rubies/ruby-2.0.0-p481/bin/rake db:migrate
  EOL
  action :nothing
end

data_bag = Chef::EncryptedDataBagItem.load('password','redmine')
redmine_password = data_bag['password']

template "database.yml" do
  path "/usr/share/#{dirname}/config/database.yml"
  user  "root"
  group "root"
  mode  0644
  variables ({
               :database_name     => node[:redmine][:database][:name],
               :database_user     => node[:redmine][:database][:user],
               :database_server   => node[:redmine][:database][:server],
               :database_password => redmine_password
 })

  notifies :run, 'execute[createdb]'
end

execute "passenger-install-apache2-module" do
  command "passenger-install-apache2-module --auto"
  action :nothing
end

execute "a2ensite-redmine" do
  command "a2ensite redmine"
  action :nothing
end

template "site-redmine" do
  path "/etc/apache2/sites-available/redmine"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[apache2]'
  notifies :run, 'execute[a2ensite-redmine]'
end

execute "ruby" do
  cwd     "/tmp"
  command "/usr/local/rvm/bin/rvm use 2.0.0 ; ruby -v"
  action :run
end
