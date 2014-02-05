# Set vip for cinder-volume service and iscsi connection
include_attribute "openstack-block-storage"

case platform
when "ubuntu"
  default["openstack"]["block-storage"]["platform"]["mysql_python_packages"] = []
  default["openstack"]["block-storage"]["platform"]["postgresql_python_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_common_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_api_packages"] = ["openstack"]
  default["openstack"]["block-storage"]["platform"]["cinder_volume_packages"] = ["openstack"]
  default["openstack"]["block-storage"]["platform"]["cinder_scheduler_packages"] = []
  default["openstack"]["block-storage"]["platform"]["cinder_iscsitarget_packages"] = []
end

# Set volume default quota
default["openstack"]["block-storage"]["quota_volumes"] = 500
default["openstack"]["block-storage"]["quota_snapshots"] = 500
default["openstack"]["block-storage"]["quota_gigabytes"] = 250000

# See the case in attributes/ipc_ng.rb
default["openstack"]["block-storage"]["enabled_backends"] = {}
default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = []

# Use syslog by default
default["openstack"]["block-storage"]["syslog"]["use"] = true

# process monitoring
default["openstack"]["block-storage"]["api_processes"] = [
  { "name" =>  "cinder-api", "shortname" =>  "cinder-api" },
  { "name" =>  "cinder-scheduler", "shortname" =>  "cinder-schedule" }
]

default["openstack"]["block-storage"]["volume_processes"] = [
  { "name" =>  "cinder-volume", "shortname" =>  "cinder-volume" }
]
