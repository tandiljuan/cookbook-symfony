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
