#!/bin/bash
apt-get update
apt-get -y install curl

# create staging directories
if [ ! -d /drop ]; then
  mkdir /drop
fi
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# download the Chef server package
if [ ! -f /downloads/chef-server-core_12.17.33_amd64.deb ]; then
  echo "[INFO]: Downloading the Chef server package..."
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/14.04/chef-server-core_12.17.33-1_amd64.deb
fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
  echo "[INFO]: Installing Chef server..."
  dpkg -i /downloads/chef-server-core_12.17.33-1_amd64.deb
  chef-server-ctl reconfigure

  echo "[INFO]: Waiting for services..."
  until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

  echo "[INFO]: Creating initial user and organization..."
  mkdir -p /vagrant/secrets
  chef-server-ctl user-create chefadmin Chef Admin admin@4thcoffee.com insecurepassword --filename /vagrant/secrets/chefadmin.pem
  chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc." --association_user chefadmin --filename /vagrant/secrets/4thcoffee-validator.pem
fi

# copy admin RSA private key to share
#echo "[INFO]: Copying admin key to /vagrant/secrets..."
#mkdir -p /home/vagrant/secrets
#cp -f /home/vagrant/chefadmin.pem /vagrant/secrets
#cp -f /home/vagrant/4thcoffee-validator.pem /vagrant/secrets

echo "[INFO]: Your Chef server is ready!"

#Install ChefDK
echo "[INFO]: Downloading ChefDK..."
wget https://packages.chef.io/files/stable/chefdk/3.1.0/ubuntu/14.04/chefdk_3.1.0-1_amd64.deb
echo "[INFO]: Installing ChefDK..."
dpkg -i chefdk_3.1.0-1_amd64.deb

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
#echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile

mkdir -p /vagrant/.chef/
cat << EOF > /vagrant/.chef/knife.rb
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'chefadmin'
client_key               "#{current_dir}/chefadmin.pem"
chef_server_url          'https://10.2.1.10/organizations/4thcoffee'
ssl_verify_mode   :verify_none
EOF

cp /vagrant/secrets/chefadmin.pem /vagrant/.chef
cp /vagrant/secrets/4thcoffee-validator.pem /vagrant/.chef

#Install Management Console
echo "[INFO]: Installing Management Console..."
chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure --accept-license

#Install Java 8
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get -y install openjdk-8-jre

cat /home/vagrant/secrets > /root/.ssh/authorized_keys

#Install Docker
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce

# Install Chef Push Jobs
#echo "[INFO]: Installing Chef Push Jobs..."
#chef-server-ctl install opscode-push-jobs-server
#chef-server-ctl reconfigure
#opscode-push-jobs-server-ctl reconfigure

#echo "[INFO]: Installing knife push jobs plugin..."
#chef gem install knife-push

#Get SSL Certificate 
#echo "[INFO]: Getting SSL Certificate..."
#knife ssl fetch -c /home/vagrant/.chef/knife.kb

#mkdir -p /home/vagrant/.chef/trusted_certs
#cp /var/opt/opscode/nginx/ca/chefserver.crt /home/vagrant/.chef/trusted_certs/
#chmod 644 ~/vagrant/.chef/trusted_certs/chefserver.crt

