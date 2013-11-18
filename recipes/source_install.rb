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

git "#{Chef::Config[:file_cache_path]}/cinder" do
  repository node["openstack"]["block-storage"]["cinder"]["git_repo"]
  reference node["openstack"]["block-storage"]["cinder"]["git_ref"]
  action :sync
  notifies :install, "python_pip[cinder-pip-requires]", :immediately
  notifies :run, "bash[install_cinder]", :immediately
end

python_pip "cinder-pip-requires" do
  package_name "#{Chef::Config[:file_cache_path]}/cinder/requirements.txt"
  options "-r"
  action :nothing
end

bash "install_cinder" do
  cwd "#{Chef::Config[:file_cache_path]}/cinder"
  code <<-EOF
    python ./setup.py install
  EOF
  action :nothing
end

directory "/var/log/cinder" do
  owner node["openstack"]["block-storage"]["user"]
  group "adm"
  mode 00750
  action :create
end
