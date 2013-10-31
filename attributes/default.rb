# Set vip for cinder-volume service and iscsi connection
include_attribute "openstack-block-storage"

case platform
when "ubuntu"
  default["openstack"]["block-storage"]["platform"]["mysql_python_packages"] = []
  default["openstack"]["block-storage"]["platform"]["postgresql_python_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_common_packages"] = ["python-cinderclient"]
  default["openstack"]["block-storage"]["platform"]["cinder_api_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_volume_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_scheduler_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_iscsitarget_packages"] = []
  default["openstack"]["block-storage"]["platform"]["package_overrides"] =
    "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
end
default["openstack"]["block-storage"]["cinder"]["git_repo"] = "https://github.com/openstack/cinder"
default["openstack"]["block-storage"]["cinder"]["git_ref"] = "master"

# See the case in attributes/ipc_ng.rb
default["openstack"]["block-storage"]["enabled_backends"] = {}
default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = []
