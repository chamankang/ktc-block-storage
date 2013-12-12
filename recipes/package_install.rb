include_recipe "sudo"
include_recipe "git"
include_recipe "python"

user node["openstack"]["block-storage"]["user"] do
  home "/var/lib/cinder"
  shell "/bin/false"
  supports :manage_home => true
end

sudo "cinder_sudoers" do
  user     "cinder"
  host     "ALL"
  runas    "root"
  nopasswd true
  commands ["/usr/local/bin/cinder-rootwrap"]
end

node["openstack"]["block-storage"]["platform"]["pip_requires_packages"].each do
  |pkg| package pkg do
    action :install
  end
end

python_pip "cinder-pip-requires" do
  package_name "#{Chef::Config[:file_cache_path]}/cinder/requirements.txt"
  options "-r"
  action :nothing
end

directory "/var/log/cinder" do
  owner node["openstack"]["block-storage"]["user"]
  group "adm"
  mode 00750
  action :create
end

if node["cinder_version"].nil?
  package "cinder" do
    action :install
  end
else
  package "cinder" do
    action :install
    version node["cinder_version"]
  end
end
