#!/bin/bash

#Install Chef Client
echo "[INFO]: Installing Chef Client"
wget https://packages.chef.io/files/stable/chef/14.1.12/ubuntu/16.04/chef_14.1.12-1_amd64.deb
dpkg -i chef_14.1.12-1_amd64.deb

#Install Pushy Client
#echo "[INFO]: Installing Pushy Client"
#wget https://packages.chef.io/files/stable/push-jobs-client/2.1.4/ubuntu/14.04/push-jobs-client_2.1.4-1_amd64.deb
#dpkg -i push-jobs-client_2.1.4-1_amd64.deb

#RUN THIS AFTER knife bootstrap 10.1.1.20 -x vagrant -P vagrant --sudo -N chefclient1 ON WORKSTATION
#cp /home/vagrant/.chef/ /etc/chef/client.pem

cat << EOF > /etc/chef/client.rb
log_level	:info
ssl_verify_mode	:verify_none
chef_server_url	"https://10.2.1.10/organizations/4thcoffee"
validation_client_name	'4thcoffee-validator'
validation_key	"/vagrant/secrets/4thcoffee-validator.pem"
EOF
chmod 0644 /etc/chef/client.rb

cat << EOF > /etc/chef/push-jobs-client.rb
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'chefclient1'
client_key  '/etc/chef/client.pem'
chef_server_url          'https://10.2.1.10/organizations/4thcoffee'
allow_unencrypted :true
ssl_verify_mode :verify_none
whitelist ({
  "ntpdate" => "ntpdate -u time",
  'chef-client' => 'chef-client'
})
EOF

echo "[INFO]: Start Chef Client"
cd /etc/chef/
chef-client

#echo "[INFO]: Start Pushy-Client"
#pushy-client -c push-jobs-client.rb