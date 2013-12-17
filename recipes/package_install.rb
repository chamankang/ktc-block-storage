include_recipe "sudo"
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
  package_name "#{Chef::Config[:file_cache_path]}/cookbooks/ktc-block-storage/files/default/requirements.txt"
  options "-r"
  action :install
end

directory "/var/log/cinder" do
  owner node["openstack"]["block-storage"]["user"]
  group "adm"
  mode 00750
  action :create
end

# package not signed, force install
case node["platform"]
when "ubuntu"
  pkg_options = "--force-yes"
else
  pkg_options = ""
end

package "cinder" do
  action :install
  version node["cinder_version"] unless node["cinder_version"].nil?
  options pkg_options
end
