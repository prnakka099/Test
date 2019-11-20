#! /bin/bash
# Updating the instance
sudo yum update -y
# Installing Ansible
sudo amazon-linux-extras install ansible2 -y
# Insalling python 3
sudo yum install python3 -y
# Installing pip
sudo yum install python-pip -y
# Installing pexpect
sudo pip install pexpect
# Installing Jq
sudo yum install jq -y