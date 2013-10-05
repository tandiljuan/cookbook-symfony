include_recipe "apt"
include_recipe "vim"

if node[:smbfs][:install] === true
  node[:smbfs][:mounts].keys.each do |mount_point|
    directory mount_point do
      recursive true
      action :create
    end
  end
  include_recipe "smbfs::attribute_driven"
end
