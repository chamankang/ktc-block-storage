#
# Cookbook Name:: ktc-block-storage
# Recipe:: volume
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

include_recipe "services"
include_recipe "ktc-utils"

KTC::Attributes.set

# giant fucking hack
# TODO: Figure out why this isn't working upstream
if node.platform_family == "debian"
  package "qemu-utils"
  package "nfs-common"
end

include_recipe "ktc-block-storage::source_install"
include_recipe "openstack-common"
include_recipe "openstack-common::logging"

chef_gem "chef-rewind"
require 'chef/rewind'

cookbook_file "/etc/init/cinder-volume.conf" do
  source "etc/init/cinder-volume.conf"
  action :create
end

include_recipe "ktc-block-storage::cinder-common"
include_recipe "openstack-block-storage::volume"

rewind :service => "cinder-volume" do
  provider Chef::Provider::Service::Upstart
  subscribes :restart, "template[/etc/cinder/cinder.conf]"
  subscribes :restart, "template[/etc/cinder/nfs_shares]"
end

rewind :service => "iscsitarget" do
  action :nothing
end

rewind :template => "/etc/tgt/targets.conf" do
  action :nothing
end

# process monitoring and sensu-check config
processes = node['openstack']['block-storage']['volume_processes']

processes.each do |process|
  sensu_check "check_process_#{process['name']}" do
    command "check-procs.rb -c 10 -w 10 -C 1 -W 1 -p #{process['name']}"
    handlers ["default"]
    standalone true
    interval 30
  end
end

ktc_collectd_processes "block-storage-volume-processes" do
  input processes
end