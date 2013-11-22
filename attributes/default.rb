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
  default["openstack"]["block-storage"]["platform"]["cinder_nfs_packages"] = ["nfs-common"]
  default["openstack"]["block-storage"]["platform"]["package_overrides"] =
    "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  default["openstack"]["block-storage"]["platform"]["pip_requires_packages"] = %w{
    libxml2-dev libxslt-dev python-mysqldb
  }
end
default["openstack"]["block-storage"]["cinder"]["git_repo"] = "https://github.com/openstack/cinder"
default["openstack"]["block-storage"]["cinder"]["git_ref"] = "master"

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
