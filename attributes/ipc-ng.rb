return unless chef_environment == "ipc-ng"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "10.217.248.119",
    "mount_point" => "/volumes/pool1-t1spod1-dmzdev/cinder01",
    "management_url" => "http://admin:xw6RQkpwE4@10.8.8.240:2000/",
    "zone_name" => "cheonan.dev.dmz"
  },
  {
    "server_ip" => "10.217.248.120",
    "mount_point" => "/volumes/pool2-t1spod1-dmzdev/cinder02",
    "management_url" => "http://admin:xw6RQkpwE4@10.8.8.241:2000/",
    "zone_name" => "cheonan.dev.dmz"
  },
  {
    "server_ip" => "10.217.244.119",
    "mount_point" => "/volumes/pool1-t1spod1-ktisdev/cinder01",
    "management_url" => "http://admin:xw6RQkpwE4@10.9.11.240:2000/",
    "zone_name" => "cheonan.dev.ktis"
  },
  {
    "server_ip" => "10.217.244.120",
    "mount_point" => "/volumes/pool2-t1spod1-ktisdev/cinder02",
    "management_url" => "http://admin:xw6RQkpwE4@10.9.11.241:2000/",
    "zone_name" => "cheonan.dev.ktis"
  }
]
