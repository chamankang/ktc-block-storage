name              "ktc-block-storage"
maintainer        "Robert Choi"
license           "Apache 2.0"
description       "KTC-wrapper for block-storage cookbook" 
version           "0.2.0"

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{
  ktc-utils
  openstack-common
  openstack-block-storage
}.each do |dep|
  depends dep
end
