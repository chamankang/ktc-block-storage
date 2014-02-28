return unless chef_environment == 'mkd2'

include_attribute 'ktc-block-storage::default'

default['openstack']['block-storage']['enabled_backends'] = {
  'nex-nfs1' => {
    'volume_driver' => 'cinder.volume.drivers.nexenta.nfs.NexentaNfsDriver'
  }
}

default['openstack']['block-storage']['nexenta']['nfs_shares'] = [
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder1',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.ktis'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder2',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.ktis'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder3',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.ktis'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder4',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.ktis'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder5',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.dmz'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder6',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.dmz'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder7',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.dmz'
  },
  {
    'server_ip' => '172.27.0.102',
    'mount_point' => '/volumes/pool1/cinder8',
    'management_url' => 'http://admin:cloud123go@10.5.1.131:2000/',
    'zone_name' => 'mokdong.dev.dmz'
  }
]
