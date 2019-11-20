#! /bin/bash
# Updating the instance
sudo yum update -y
# Installing Ansible
sudo amazon-linux-extras install ansible2 -y
# Installing Java
sudo yum install java-1.8.0 -y
# Installing nfs tools
sudo yum -y install nfs-utils
# Installing sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip
sudo unzip sonarqube-7.6.zip -d /mnt/sonar
sudo groupadd sonar
sudo useradd -c "Sonar System User" -d /mnt/sonar -g sonar -s /bin/bash sonar
sudo chown -R sonar:sonar /mnt/sonar