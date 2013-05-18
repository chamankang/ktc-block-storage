#
# Cookbook Name:: ktc-cinder
# Recipe:: default
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

cookbook_file node['cinder']['services']['volume']['register_script'] do
  source "crm_register"
  owner "root"
  group "root"
  mode 0755
  action :create_if_missing
end

cookbook_file node['cinder']['services']['volume']['delete_script'] do
  source "crm_delete"
  owner "root"
  group "root"
  mode 0755
  action :create_if_missing
  notifies :create, "cookbook_file[/etc/cinder/rootwrap.d/volume.filters]", :immediately
end

cookbook_file "/etc/cinder/rootwrap.d/volume.filters" do
  source "volume_filters"
  owner "root"
  group "root"
  mode 0755
  action :nothing
  notifies :create, "cookbook_file[/usr/share/pyshared/cinder/volume/iscsi.py]", :immediately
end

cookbook_file "/usr/share/pyshared/cinder/volume/iscsi.py" do
  source "iscsi.py"
  owner "root"
  group "root"
  mode 0755
  action :nothing
  notifies :create, "ruby_block[add-host-myip-to-cinder-volume]", :immediately
end

ruby_block 'add-host-myip-to-cinder-volume' do
  block do
    myip_line = "myip = #{node['cinder']['services']['volume']['myip']}"
    host_line = "host = #{node['cinder']['services']['volume']['host']}"

    conf_file = Chef::Util::FileEdit.new "/etc/cinder/cinder.conf"
    conf_file.insert_line_after_match(/iscsi_ip_address/, myip_line)
    conf_file.insert_line_after_match(/iscsi_ip_address/, host_line)
  
    system('touch /var/lock/.cinder_conf_edit_done')
  end
  action :nothing
  not_if "test -f /var/lock/.cinder_conf_edit_done"
end
