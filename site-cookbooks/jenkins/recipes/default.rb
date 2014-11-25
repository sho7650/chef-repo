#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
package "curl" do
  action :install
end

execute "adding-gpg-td" do
  command "curl -L http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -"
  not_if "apt-key list | egrep -q '^uid.*Kohsuke Kawaguchi <kohsuke.kawaguchi@sun.com>'"
end

file "jenkins.list" do
  path    "/etc/apt/sources.list.d/jenkins.list"
  content "deb http://pkg.jenkins-ci.org/debian binary/"
  owner   "root"
  group   "root"
  mode    0644
  notifies :run, 'execute[apt-get-update]', :immediately
end

package "jenkins" do
  action :install
end

service "jenkins" do
  action [ :enable, :start ]
  supports :status => true, :restart => true
end

template "jenkins" do
  path  "/etc/default/jenkins"
  owner "root"
  group "root"
  mode  0644
  notifies :restart, 'service[jenkins]'
end
