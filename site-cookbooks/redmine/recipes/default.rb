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

=begin

%w{gawk curl git imagemagick libmagickwand-dev libmysqlclient-dev apache2-threaded-dev libcurl4-gnutls-dev libreadline6-dev libssl-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison libffi-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "install_rvm" do
  user    "root"
  command "su root -l -c 'curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles'"
  action :run
  not_if { File.exists?("/usr/local/rvm/bin/rvm") }
end

execute "install_ruby2" do
  user    "root"
  command "su root -l -c 'rvm install 2.0.0'"
#  command ". /etc/profile.d/rvm.sh && /usr/local/rvm/bin/rvm install 2.0.0"
  action :run
  not_if { File.exists?("/usr/local/rvm/rubies/ruby-2.0.0-p481/bin/ruby") }
end

=end

include_recipe "apt"

execute "adding-gpg-phusion" do
  command "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7"
  not_if "apt-key list | egrep -q 'Phusion Automated Software Signing'"
end

%w{apt-transport-https ca-certificates}.each do |pkg|
  package pkg do
    action :install
  end
end

template "phusionpassenger.list" do
  path "/etc/apt/sources.list.d/phusionpassenger.list"
  owner "root"
  group "root"
  mode  0600
  notifies :run, 'execute[apt-get-update]', :immediately
end

%w{ruby ruby-dev rubygems curl git imagemagick libmagickwand-dev libmysqlclient-dev libapache2-mod-passenger}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{mysql2}.each do |gem_pkg|
  execute "gem-install_#{gem_pkg}" do
    user    "root"
    command "su root -l -c 'gem install #{gem_pkg}'"
    not_if  "su root -l -c 'gem list | egrep -q #{gem_pkg}'"
  end
end

directory "/usr/share/#{dirname}" do
  recursive true
  owner "www-data"
  group "www-data"
end

execute "extract_#{filename}" do
  user    "www-data"
  group   "www-data"
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{filename} -C #{install_dir}"
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source   "#{remote_uri}/#{filename}"
  checksum "#{file_checksum}"
  notifies :run, "execute[extract_#{filename}]", :immediately
end

execute "install_#{filename}" do
  cwd     "#{install_dir}/#{dirname}"
  command "su root -l -c 'cd #{install_dir}/#{dirname} && bundle install --without development test postgresql sqlite'"
#  command "bundle install --without development test postgresql sqlite"
  action :nothing
end

link "/var/www/redmine" do
  owner "www-data"
  group "www-data"
  to    "/usr/share/#{dirname}/public"
  notifies :restart, 'service[apache2]'
end

=begin
execute "uninstall-psych" do
  command "su root -l -c 'gem uninstall psych'"
  only_if  "su root -l -c 'gem list | egrep -q psych*2.0.5'"
end
=end

execute "createdb" do
  cwd  "#{install_dir}/#{dirname}"
  user "root"
  command "su root -l -c 'cd #{install_dir}/#{dirname} && rake generate_secret_token && RAILS_ENV=production rake db:migrate'"
  action :nothing
  environment ({'RAILS_ENV' => 'production'})
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
  notifies :run, "execute[install_#{filename}]"
end

template "configuration.yml" do
  path "/usr/share/#{dirname}/config/configuration.yml"
  owner "root"
  group "www-data"
  mode  0640
  notifies :restart, 'service[apache2]'
  notifies :run, "execute[install_#{filename}]"
end  

template "passenger.conf" do
  path "/etc/apache2/mods-available/passenger.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[apache2]'
end  

directory "plugin_assets" do
  path  "usr/share/#{dirname}/public/plugin_assets"
  owner "www-data"
  group "www-data"
  mode 0755
end

=begin
execute "gem-install-passenger" do
  user    "root"
  command "su root -l -c 'gem install passenger --no-ri --no-rdoc'"
  action :run
  not_if "su root -l -c 'gem list | egrep -q passenger'"
end

execute "passenger-install-apache2-module" do
  user    "root"
  command "su root -l -c 'passenger-install-apache2-module --auto'"
  action :run
#  not_if "su root -l -c 'gem list | egrep -q passenger'"
end
=end

execute "a2ensite-redmine" do
  command "a2ensite redmine"
  action :nothing
end

execute "a2enmod-passenger" do
  command "a2enmod passenger"
  action :nothing
end

template "site-redmine" do
  path "/etc/apache2/sites-available/redmine"
  owner "root"
  group "root"
  mode  0644
  notifies :run, 'execute[a2ensite-redmine]'
  notifies :run, 'execute[a2enmod-passenger]'
  notifies :restart, 'service[apache2]'
end
