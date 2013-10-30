return unless chef_environment == "mkd_stag"

include_attribute "ktc-block-storage::default"

default["openstack"]["block-storage"]["enabled_backends"] = {
  "nex-nfs1" => {
    "volume_driver" => "cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver",
    "nexenta_host" => "snode1"
  }
}
default["openstack"]["block-storage"]["nexenta"]["nfs_shares"] = [
  {
    "server_ip" => "snode1-disk",
    "mount_point" => "/volumes/mkd-stag-snode2-zpool1/cinder1",
    "management_url" => "http://admin:nexenta@snode1:2000/"
  },
  {
    "server_ip" => "snode2-disk",
    "mount_point" => "/volumes/mkd-stag-snode2-zpool1/cinder1",
    "management_url" => "http://admin:nexenta@snode2:2000/"
  }
]
