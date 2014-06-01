include_recipe "composer"

# Install extra modules for PHP needed by Symfony
%w{php5-intl php-apc}.each do |pkg|
  package pkg do
    action :install
  end
end

# Install project vendors
composer_project node[:core][:project_path] do
    dev true
    quiet false
    prefer_dist false
    action :install
end

# Fill parameters.yml file with proper values
bash "update_parameters_file" do
  cwd "#{node[:core][:project_path]}/app/config"
  code <<-EOH
    sed -i \
        -e 's/database_host:.*/database_host: localhost/g' \
        -e 's/database_name:.*/database_name: #{node[:symfony][:database_name]}/g' \
        -e 's/database_user:.*/database_user: #{node[:symfony][:database_user]}/g' \
        -e 's/database_password:.*/database_password: #{node[:symfony][:database_pass]}/g' \
        parameters.yml
  EOH
end

# Create app_dev.php file if it doesn't exist
file "#{node[:core][:project_path]}/web/app_dev.php" do
  content ::File.open("#{node[:core][:project_path]}/web/app_dev.php.dist").read
  mode 0644
  action :create_if_missing
end

# Link app.php to app_dev.php
link "#{node[:core][:project_path]}/web/app.php" do
  to "app_dev.php"
  not_if { ::File.exist? "#{node[:core][:project_path]}/web/app.php" }
end

# Create config.php file if it doesn't exist
file "#{node[:core][:project_path]}/web/config.php" do
  content ::File.open("#{node[:core][:project_path]}/web/config.php.dist").read
  mode 0644
  action :create_if_missing
end
