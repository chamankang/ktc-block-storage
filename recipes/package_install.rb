include_recipe "sudo"
include_recipe "python"
include_recupe "ktc-package"

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

src = "https://raw.github.com/openstack/cinder/stable/havana/requirements.txt"
loc = "#{Chef::Config[:file_cache_path]}/requirements.txt"

remote_file loc do
  source src
  not_if { ::File.exist?(loc) }
end

python_pip "cinder-pip-requires" do
  package_name loc
  options "-r"
  action :install
end

directory "/var/log/cinder" do
  owner node["openstack"]["block-storage"]["user"]
  group "adm"
  mode 00750
  action :create
end

package "cinder" do
  action :install
  version node["cinder_version"] unless node["cinder_version"].nil?
end
