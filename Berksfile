#
# vim: set ft=ruby:
#
site :opscode

metadata

cookbook 'ktc-database', github: 'cloudware-cookbooks/ktc-database', branch: 'develop'
cookbook 'ktc-etcd', github: 'cloudware-cookbooks/ktc-etcd', branch: 'develop'
cookbook 'ktc-identity', github: 'cloudware-cookbooks/ktc-identity', branch: 'develop'
cookbook 'ktc-memcached', github: 'cloudware-cookbooks/ktc-memcached', branch: 'develop'
cookbook 'ktc-messaging', github: 'cloudware-cookbooks/ktc-messaging', branch: 'develop'
cookbook 'ktc-utils', github: 'cloudware-cookbooks/ktc-utils', branch: 'develop'
# until they cut a realease that fixes this bug:
# https://github.com/opscode-cookbooks/memcached/commit/d527134987d4e53bb86bd2319b1f1cbf8171355a
cookbook 'memcached', github: 'opscode-cookbooks/memcached'
cookbook 'openstack-block-storage', github: 'stackforge/cookbook-openstack-block-storage'
cookbook "openstack-common", github: "stackforge/cookbook-openstack-common"
cookbook "openstack-compute", github: "stackforge/cookbook-openstack-compute"
cookbook "openstack-dashboard", github: "stackforge/cookbook-openstack-dashboard"
cookbook "openstack-identity", github: "stackforge/cookbook-openstack-identity"
cookbook "openstack-image", github: "stackforge/cookbook-openstack-image"
cookbook "openstack-metering", github: "stackforge/cookbook-openstack-metering"
cookbook "openstack-network", github: "stackforge/cookbook-openstack-network"
cookbook 'openstack-object-storage', github: 'stackforge/cookbook-openstack-object-storage'
cookbook 'openstack-ops-database', github: 'stackforge/cookbook-openstack-ops-database'
cookbook 'openstack-ops-messaging', github: 'stackforge/cookbook-openstack-ops-messaging'
cookbook 'services', github: 'spheromak/services-cookbook'

group :integration do
  cookbook 'ktc-testing', github: 'cloudware-cookbooks/ktc-testing', branch: 'master'
  cookbook 'ubuntu'
end
