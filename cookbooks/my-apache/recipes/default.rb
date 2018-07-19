apt_update 'repo' do
  action :update
end

user 'user1' do
  manage_home true
  system true
  action :create
end

apt_package 'apache2' do
  action :install
end

template '/var/www/html/index.html' do
  source 'apache.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(text: 'Welcome to Apache2 deployed by Chef!')
  action :create
end
