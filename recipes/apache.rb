#
# Cookbook Name:: cookbook-lamp
# Recipe:: apache
#
# Author:: Juan Manuel Lopez
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

# Setup athe Apache VirtualHost
web_app node[:apache][:host_name] do
  template "apache2_sites.conf.erb"
  server_name node[:apache][:host_name]
  server_aliases node[:apache][:aliases]
  docroot node[:apache][:project_web_path]
  listen_ports node[:apache][:listen_ports]
  listen_addresses node[:apache][:listen_addresses]
end

# Setup the ports that Apache is going to listen
template "/etc/apache2/ports.conf" do
  source "apache2_ports.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  variables ({
    :listen_ports => node[:apache][:listen_ports],
    :listen_addresses => node[:apache][:listen_addresses]
  })
  notifies :restart, resources("service[apache2]"), :delayed
end

# Update hosts file with the host name and aliases
hosts_line = "127.0.0.1 #{node[:apache][:host_name]} #{node[:apache][:aliases].join(' ')}"
bash "hosts" do
  code "echo #{hosts_line} >> /etc/hosts"
  not_if do
    File.readlines('/etc/hosts').grep(/#{hosts_line}/).length > 0
  end
end
