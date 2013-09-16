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
volume_api = Services::Member.new node.default.fqdn,
  service: "volume-api",
  port: 8776,
  proto: "tcp",
  ip: ip

volume_api.save

KTC::Attributes.set

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "openstack-block-storage::api"
include_recipe "openstack-block-storage::volume"
include_recipe "openstack-block-storage::scheduler"
include_recipe "openstack-block-storage::identity_registration"
