#
# Cookbook Name:: iscsi
# Attribute:: default
#
# Copyright 2014, sho kisaragi
#
# All rights reserved - Do Not Redistribute
#

# for LVM

default['lvm']['vg_name']                 = "vg_iscsi01"
default['lvm']['lv_name']                 = "lv_lvm01"
default['lvm']['mount_point']             = "/mnt/internal"
default['lvm']['file_system']             = "ext4"
