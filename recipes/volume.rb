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

include_recipe "ktc-block-storage::source_install"
include_recipe "openstack-common"
include_recipe "openstack-common::logging"

chef_gem "chef-rewind"
require 'chef/rewind'

%w{ volume }.each do |agent|
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

rewind :service => "iscsitarget" do
  action :nothing
end

rewind :template => "/etc/tgt/targets.conf" do
  action :nothing
end
