#
# Cookbook Name:: cookbook-symfony
# Recipe:: php
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

include_recipe "php"

# Install extra modules for PHP
%w{php5-mysql php5-xsl php5-gd php5-curl}.each do |pkg|
  package pkg do
    action :install
  end
end

# Check if Apache is installed
apache_installed = false
ruby_block "check_apache_installed" do
  block do
    if File.directory? node[:apache][:dir]
      apache_installed = true
    end
  end
  action :create
end

# Install Apache's mod_php5 only if Apache is installed
if apache_installed
  include_recipe "apache2::mod_php5"
  log "Restart Apache after installation of mod_php5" do
    level :info
    notifies :restart, resources("service[apache2]"), :delayed
  end
end
