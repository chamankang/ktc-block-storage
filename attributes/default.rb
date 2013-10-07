# Set vip for cinder-volume service and iscsi connection
case platform
when "ubuntu"
  default["openstack"]["block-storage"]["platform"] = {
    "mysql_python_packages" => [],
    "postgresql_python_packages" => [],
    "cinder_common_packages" => [],
    "cinder_api_packages" => [],
    "cinder_volume_packages" => [],
    "cinder_scheduler_packages" => [],
    "cinder_iscsitarget_packages" => [],
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
default["openstack"]["block-storage"]["cinder"]["git_repo"] = "https://github.com/openstack/cinder"
default["openstack"]["block-storage"]["cinder"]["git_ref"] = "master"
