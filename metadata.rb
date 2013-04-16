name              "ktc-cinder"
maintainer        "Robert Choi"
license           "Apache 2.0"
description       "Customize cinder-volume to be used with pacemaker" 
version           "0.1.0"

recipe "default", "Customize cinder-volume code and add additional scripts."

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end

depends "cinder"
