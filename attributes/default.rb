# Vagrant Settings
default[:vagrant][:workspace_path] = '/opt/vboxsf/workspace'
default[:vagrant][:workspace_nfs_path] = '/opt/nfs/workspace'

# Core settings
default[:core][:workspace_path] = '/opt/workspace'
default[:core][:project_path]   = node[:core][:workspace_path]

# SAMBA Settings
default[:smbfs][:install] = false

# Apache2 Settings
normal[:apache][:user]             = 'vagrant'
normal[:apache][:group]            = 'vagrant'
normal[:apache][:host_name]        = 'example.com'
normal[:apache][:aliases]          = ['www.example.com']
normal[:apache][:listen_addresses] = '*'
normal[:apache][:listen_ports]     = ['80']
normal[:apache][:project_web_path] = node[:core][:workspace_path]

# PHP Settings
normal[:php][:directives]['date.timezone'] = 'America/Los_Angeles';
normal[:php][:directives]['short_open_tag'] = 'Off';

# MySQL Settings
default['mysql']['server_root_password']   = 'vagrant'
default['mysql']['server_repl_password']   = 'vagrant'
default['mysql']['server_debian_password'] = 'vagrant'

# Symfony Settings
default[:symfony][:database_name] = 'vagrant'
default[:symfony][:database_user] = 'root'
default[:symfony][:database_pass] = 'vagrant'
