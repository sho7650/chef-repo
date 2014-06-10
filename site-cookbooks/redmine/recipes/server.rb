include_recipe "apt"

template "wheezy-backport.list" do
  path "/etc/apt/sources.list.d/wheezybackport.list"
  owner "root"
  group "root"
  mode  0644
  notifies :run, 'execute[apt-get-update]', :immediately
end

%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{redmine redmine-mysql}.each do |pkg|
  package pkg do
    action  :install
    version "2.4.2-1~bpo70+1"
    options "-t wheezy-backports"
  end
end

package "libapache2-mod-passenger" do
  action  :install
  version "4.0.10-1~bpo7+1"
  options "-t wheezy-backports"
end

directory "/usr/share/redmine/" do
  recursive true
  owner "www-data"
  group "www-data"
end

link "/var/www/redmine" do
  owner "www-data"
  group "www-data"
  to    "/usr/share/redmine/public"
  notifies :restart, 'service[apache2]'
end

template "passenger.conf" do
  path "/etc/apache2/mods-available/passenger.conf"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[apache2]'
end  

template "configuration.yml" do
  path "/etc/redmine/default/configuration.yml"
  owner "root"
  group "www-data"
  mode  0640
  notifies :restart, 'service[apache2]'
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
  notifies :run, 'execute[a2ensite-redmine]'
  notifies :restart, 'service[apache2]'
end

