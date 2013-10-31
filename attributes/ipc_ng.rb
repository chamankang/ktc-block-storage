return unless chef_environment == "ipc_ng"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "10.100.0.21",
    "mount_point" => "/volumes/ipc-preprod-pod1-zpool0/cinder1",
    "management_url" => "http://admin:nexenta@10.100.0.21:2000/"
  },
  {
    "server_ip" => "10.100.0.22",
    "mount_point" => "/volumes/ipc-preprod-pod2-zpool0/cinder1",
    "management_url" => "http://admin:nexenta@10.100.0.22:2000/"
  }
]
