name              "ktc-block-storage"
maintainer        "Robert Choi"
license           "Apache 2.0"
description       "KTC-wrapper for block-storage cookbook"
version '0.2.16'

%w{ centos ubuntu }.each do |os|
  supports os
end

depends "ktc-logging"
depends "ktc-monitor"
depends "ktc-package"
depends "ktc-utils", ">= 0.3.3"
depends "openstack-block-storage", "~> 7.0.1"
depends "openstack-common", "~> 0.4.3"
depends "python"
depends "services", ">= 1.1.1"
depends "sudo"
