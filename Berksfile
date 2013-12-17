#
# vim: set ft=ruby:
#

chef_api "https://cookbooks.mkd2.ktc", node_name: "cookbook", client_key: ".cookbook.pem"

site :opscode

metadata

group :integration do
  cookbook 'etcd'
  cookbook 'ktc-database'
  cookbook 'ktc-identity'
  cookbook 'ktc-memcached'
  cookbook 'ktc-messaging'
  cookbook 'ktc-testing'
end
