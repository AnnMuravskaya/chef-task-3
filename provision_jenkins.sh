#!/bin/bash
apt-get update
#apt-get -y install curl

#Install Java 8
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get -y install openjdk-8-jre

#Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get -y install jenkins
service jenkins start

apt-get install git-core

#useradd jenkins -U -s /bin/bash

#ssh-keygen -t rsa
#cp /root/.ssh/id_rsa.pub /home/vagrant/secrets

