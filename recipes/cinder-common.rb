chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "openstack-block-storage::cinder-common"

rewind :template => "/etc/cinder/cinder.conf" do
  cookbook "ktc-block-storage"
end

# This will copy recursively all the files in
# /files/default/etc/cinder/rootwrap.d
remote_directory "/etc/cinder/rootwrap.d" do
  source "etc/cinder/rootwrap.d"
  files_owner node["openstack"]["block-storage"]["user"]
  files_group node["openstack"]["block-storage"]["group"]
  files_mode 00700
end

cookbook_file "/etc/cinder/rootwrap.conf" do
  source "rootwrap.conf"
  owner node["openstack"]["block-storage"]["user"]
  group node["openstack"]["block-storage"]["group"]
  mode 00644
end

template "/etc/cinder/nfs_shares" do
  source "nfs_shares.erb"
  owner  node["openstack"]["block-storage"]["user"]
  group  node["openstack"]["block-storage"]["group"]
  mode 00600

  notifies :restart, "service[cinder-volume]", :immediately
end
