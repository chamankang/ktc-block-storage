#
# Cookbook Name:: ktc-cinder
# Recipe:: volume
#
# Author: Robert Choi <taeilchoi1@gmail.com>
# Copyright 2013 by Robert Choi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "cinder::cinder-volume"

template "/etc/cinder/rootwrap.d/volume.filters" do
  source "volume_filters.erb"
  owner "root"
  group "root"
  mode 0755
  action :create
  notifies :create, "cookbook_file[/usr/share/pyshared/cinder/volume/iscsi.py]", :immediately
end

cookbook_file "/usr/share/pyshared/cinder/volume/iscsi.py" do
  source "iscsi.py"
  owner "root"
  group "root"
  mode 0755
  action :nothing
  notifies :create, "ruby_block[add-host-myip-to-cinder-conf]", :immediately
end

glance_info = get_access_endpoint("glance", "glance", "api")

ruby_block 'add-host-myip-to-cinder-conf' do
  block do
    myip_line = "myip = #{node['cinder']['services']['volume']['myip']}"
    host_line = "host = #{node['cinder']['services']['volume']['host']}"
    glance_host_line = "glance_host = #{glance_info["host"]}"
    glance_port_line = "glance_port = #{glance_info["port"]}"

    conf_file = Chef::Util::FileEdit.new("/etc/cinder/cinder.conf")
    conf_file.insert_line_after_match(/rabbit_port.*/, glance_port_line)
    conf_file.insert_line_after_match(/rabbit_port.*/, glance_host_line)
    conf_file.insert_line_after_match(/iscsi_ip_address.*/, myip_line)
    conf_file.insert_line_after_match(/iscsi_ip_address.*/, host_line)
    conf_file.write_file
  
    system('touch /var/lock/.cinder_conf_myip_add_done')
  end
  action :nothing
  notifies :restart, "service[cinder-volume]", :immediately
  not_if "test -f /var/lock/.cinder_conf_myip_add_done"
end
