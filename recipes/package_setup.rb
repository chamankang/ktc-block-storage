include_recipe "sudo"
include_recipe "ktc-package"

group node["openstack"]["block-storage"]["group"] do
  system true
end

user node["openstack"]["block-storage"]["user"] do
  home "/var/lib/cinder"
  gid node["openstack"]["block-storage"]["group"]
  shell "/bin/sh"
  system true
  supports :manage_home => true
end

sudo "cinder_sudoers" do
  user     "cinder"
  host     "ALL"
  runas    "root"
  nopasswd true
  commands ["/usr/local/bin/cinder-rootwrap"]
end

%w|
  /var/cache/cinder
  /var/cache/cinder/api
  /var/lib/cinder/.python-eggs
  /var/log/cinder
  /var/run/cinder
|.each do |d|
  directory "#{d}" do
    owner node["openstack"]["block-storage"]["user"]
    group node["openstack"]["block-storage"]["group"]
    mode 00755
    action :create
  end
end

%w/
  cinder-all
  cinder-api
  cinder-backup
  cinder-clear-rabbit-queues
  cinder-manage
  cinder-rootwrap
  cinder-rpc-zmq-receiver
  cinder-scheduler
  cinder-volume
  cinder-volume-usage-audit
/.each do |p|
  link "/usr/bin/#{p}" do
    to "/opt/openstack/cinder/bin/#{p}"
  end
end
