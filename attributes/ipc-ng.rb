return unless chef_environment == "ipc-ng"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "10.217.244.119",
    "mount_point" => "/volumes/pool1-t1spod1-dmzdev/cinder01",
    "zone_name" => "dmz-dev"
  },
  {
    "server_ip" => "10.217.244.120",
    "mount_point" => "/volumes/pool2-t1spod1-dmzdev/cinder02",
    "zone_name" => "dmz-dev"
  },
  {
    "server_ip" => "10.217.244.119",
    "mount_point" => "/volumes/pool1-t1spod1-ktisdev/cinder01",
    "zone_name" => "ktis-dev"
  },
  {
    "server_ip" => "10.217.244.120",
    "mount_point" => "/volumes/pool2-t1spod1-ktisdev/cinder02",
    "zone_name" => "ktis-dev"
  }
]
