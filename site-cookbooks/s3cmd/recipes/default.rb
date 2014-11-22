#
# Cookbook Name:: s3cmd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "s3cmd" do
  action :install
end

data_bag = Chef::EncryptedDataBagItem.load('accesskey','aws')

aws_access_key = data_bag['accesskey']
aws_secret_key = data_bag['secretkey']
aws_gpg_passphrase = data_bag['gpgpassphrase']

template "s3cfg" do
  path  "/root/.s3cfg"
  owner "root"
  group "root"
  mode  0600
  variables ({
               :access_key => aws_access_key,
               :secret_key => aws_secret_key,
               :gpg_passphrase => aws_gpg_passphrase
             })
end
