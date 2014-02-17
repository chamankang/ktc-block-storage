return unless chef_environment == "ipc-prod"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "10.220.88.113",
    "mount_point" => "/volumes/pool1-t2spod1-ktisprod/cinder01",
    "management_url" => "http://admin:xw6RQkpwE4@10.4.15.240:2000/",
    "zone_name" => "cheonan.prod.ktis"
  },
  {
    "server_ip" => "10.220.88.116",
    "mount_point" => "/volumes/pool2-t2spod1-ktisprod/cinder02",
    "management_url" => "http://admin:xw6RQkpwE4@10.4.15.241:2000/",
    "zone_name" => "cheonan.prod.ktis"
  },
  {
    "server_ip" => "10.220.88.119",
    "mount_point" => "/volumes/pool3-t2spod1-ktisprod/cinder03",
    "management_url" => "http://admin:xw6RQkpwE4@10.4.15.242:2000/",
    "zone_name" => "cheonan.prod.ktis"
  },
  {
    "server_ip" => "10.220.88.122",
    "mount_point" => "/volumes/pool4-t2spod1-ktisprod/cinder04",
    "management_url" => "http://admin:xw6RQkpwE4@10.4.15.243:2000/",
    "zone_name" => "cheonan.prod.ktis"
  }
]
