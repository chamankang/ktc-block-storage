#
# Cookbook Name:: ktc-block-storage
# Recipe:: api
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

include_recipe "services"
include_recipe "ktc-utils"

iface = KTC::Network.if_lookup "management"
ip = KTC::Network.address "management"

Services::Connection.new run_context: run_context
volume_api = Services::Member.new node['fqdn'],
  service: "volume-api",
  port: 8776,
  proto: "tcp",
  ip: ip

volume_api.save

KTC::Attributes.set

include_recipe "ktc-block-storage::source_install"
include_recipe "openstack-common"
include_recipe "ktc-logging::logging"

chef_gem "chef-rewind"
require 'chef/rewind'

%w{ api scheduler }.each do |agent|
  cookbook_file "/etc/init/cinder-#{agent}.conf" do
    source "etc/init/cinder-#{agent}.conf"
    action :create
  end

  include_recipe "ktc-block-storage::cinder-common"
  include_recipe "openstack-block-storage::#{agent}"

  rewind :service => "cinder-#{agent}" do
    provider Chef::Provider::Service::Upstart
  end
end

include_recipe "openstack-block-storage::identity_registration"


# process monitoring and sensu-check config
processes = node['openstack']['block-storage']['api_processes']

processes.each do |process|
  sensu_check "check_process_#{process['name']}" do
    command "check-procs.rb -c 10 -w 10 -C 1 -W 1 -p #{process['name']}"
    handlers ["default"]
    standalone true
    interval 30
  end
end

ktc_collectd_processes "block-storage-api-processes" do
  input processes
end
