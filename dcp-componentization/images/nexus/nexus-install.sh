#!/bin/bash
#new isntallation dierectory for nexus\
sudo yum update -y
sudo mkdir /opt/nexus
cd /opt/nexus
sudo yum install -y java-1.8.0-openjdk
#downlad the latest GZ file 
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
#untar the GZ file
sudo tar -xzvf latest-unix.tar.gz
#Rename the directory 
sudo mv nexus-3.18.1-01 nexus3
#Temp varaible config 
CONFIG=/home/ec2-user/.bashrc
echo "NEXUS_HOME=\"/opt/nexus/nexus3\""  >> "$CONFIG"
source /home/ec2-user/.bashrc
echo $NEXUS_HOME
#Run the nexus as service
echo "did the link fail"
sudo ln -s $NEXUS_HOME/bin/nexus /etc/init.d/nexus
echo "after link command"
cd /etc/init.d
sudo chkconfig --add nexus
echo "first chkconfig"
sudo chkconfig --levels 345 nexus on
echo "second chkconfig"
sudo service nexus start
