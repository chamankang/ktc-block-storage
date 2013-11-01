return unless chef_environment == "ipc-stage"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "10.210.2.23",
    "mount_point" => "/volumes/ipc-preprod-pool1/cinder1",
    "management_url" => "http://admin:nexenta@10.9.242.240:2000/"
  }
]
