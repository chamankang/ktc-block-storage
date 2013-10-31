return unless chef_environment == "mkd_stag"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver"
  }
}

default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "snode01-disk",
    "mount_point" => "/volumes/mkd-stag-snode1-zpool1/cinder1",
    "management_url" => "http://admin:nexenta@snode01:2000/"
  },
  {
    "server_ip" => "snode02-disk",
    "mount_point" => "/volumes/mkd-stag-snode2-zpool1/cinder1",
    "management_url" => "http://admin:nexenta@snode02:2000/"
  }
]
