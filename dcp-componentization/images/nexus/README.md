# Aamazon Machine Image (AMI) Creation for Nexus Using Packer

Hashicorp Packer is used to build Amazon Machine Images based on the defined configuration.

## Installation

**Amazon Base AMI Used :** Amazon Linux 2

| Variables         | Default Value | Description                                                                                |
| :---------------- | :------------ | :----------------------------------------------------------------------------------------- |
| source_ami        |               | Amazon Linux 2 Base AMI to be used (ami-0de53d8956e8dcf80)                                 |
| vpc_id            |               | VPC ID of the VPC to be used to build the image                                            |
| subnet_id         |               | Subnet ID where Packer will create an instance to install the tools and then image the EC2 |
| security_group_id |               | Security Group to be used by Packer EC2                                                    |
| instance_type     |               | Instance Type (e.g. m4.large, m5.large etc)                                                |
| region            |               | Amazon AWS region                                                                          |
| device_name       |               | This is normally /dev/xvda for AWS instances                                               |
| volume_type       |               | gp2 can be used to build an image                                                          |
| ssh_username      |               | Packer uses ec2-user as the user to install tools on EC2                                   |
| kms_key_id        |               | KMS Key to be used to encrypt the final AMI                                                |

#### Install Nexus

```
#!/bin/bash
#new isntallation dierectory for nexus
mkdir /opt/nexus
cd /opt/nexus
sudo yum install -y java-1.8.0-openjdk
#downlad the latest GZ file
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
#untar the GZ file
tar -xzvf latest-unix.tar.gz
#Rename the directory
sudo mv nexus-3.16.1-02 nexus3
#Temp varaible config
CONFIG=/home/ec2-user/.bashrc
echo "NEXUS_HOME=\"/opt/nexus/nexus3\""  >> "$CONFIG"
source /home/ec2-user/.bashrc
#Run the nexus as service
sudo ln -s $NEXUS_HOME/bin/nexus /etc/init.d/nexus
cd /etc/init.d
sudo chkconfig --add nexus
sudo chkconfig --levels 345 nexus on
sudo service nexus start

```

## Command to run script

To validate scripts

```
packer validate build.json
```

To build an image

```
packer build build.json
```
