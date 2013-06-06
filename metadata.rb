name              "ktc-cinder"
maintainer        "Robert Choi"
license           "Apache 2.0"
description       "KTC-wrapper for cinder cookbook" 
version           "0.2.0"

recipe "api", "Add some config to cinder.conf on api node"
recipe "volume", "Customize cinder-volume code and add additional scripts."

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end

depends "osops-utils"
depends "cinder"
