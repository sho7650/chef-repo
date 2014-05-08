# Cookbook Name:: ldap
# Attribute:: default
#
# Copyright 2014, oshiire
#
# All rights reserved - Do Not Redistribute
#
default['ldap']['rootdn'] = "cn=admin,dc=oshiire,dc=to"
default['ldap']['rootpw'] = "p@ssw0rd"

default['ldap']['binddn'] = "cn=proxy,dc=oshiire,dc=to"
default['ldap']['bindpw'] = "p@ssw0rd"
