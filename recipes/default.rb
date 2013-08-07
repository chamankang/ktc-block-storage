#
# Cookbook Name:: ktc-block-storage
# Recipe:: api
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe
  include KTCUtils
end

set_rabbit_servers "block-storage"
set_database_servers "volume"
set_service_endpoint_ip "volume-api"

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "openstack-block-storage::api"
include_recipe "openstack-block-storage::volume"
include_recipe "openstack-block-storage::scheduler"
include_recipe "openstack-block-storage::identity_registration"
