# Aamazon Machine Image (AMI) Creation for Sonarqube Using Packer

Hashicorp Packer is used to build Amazon Machine Images based on the defined configuration.

## Installation

**Amazon Base AMI Used :** Amazon Linux 2

| Variables              | Default Value   | Description  |
| :-------------         |:-------------   | :-----|
| source_ami         |                 |  Amazon Linux 2 Base AMI to be used (ami-0de53d8956e8dcf80) |
| vpc_id         |                |  VPC ID of the VPC to be used to build the image   |
| subnet_id         |              |  Subnet ID where Packer will create an instance to install the tools and then image the EC2   |
| security_group_id         |                |  Security Group to be used by Packer EC2 |
| instance_type         |                |  Instance Type (e.g. m4.large, m5.large etc)   |
| region         |               |  Amazon AWS region   |
| device_name         |              |  This is normally /dev/xvda for AWS instances   |
| volume_type         |               |  gp2 can be used to build an image   |
| ssh_username         |               |  Packer uses ec2-user as the user to install tools on EC2   |
| kms_key_id         |               |  KMS Key to be used to encrypt the final AMI   |


#### This installs Linux updates and amazon-efs-utils.

```
# Updating the instance
sudo yum update -y
# Installing nfs tools
sudo yum -y install nfs-utils
```     

#### Install Sonarqube 

```
# Making home directory for Sonarqube
sudo mkdir -p /mnt/Sonarqube_HOME
# Getting Sonarqube package
sudo wget https://product-downloads.atlassian.com/software/Sonarqube/downloads/atlassian-Sonarqube-software-8.1.0-x64.bin
#
sudo chmod a+x atlassian-Sonarqube-software-8.1.0-x64.bin
#
sudo cat > response.varfile <<- "EOF"
#install4j response file for Sonarqube Software 8.1.0
#Mon Apr 08 16:11:15 UTC 2019
launch.application$Boolean=true
rmiPort$Long=8005
app.SonarqubeHome=/mnt/Sonarqube_HOME
app.install.service$Boolean=true
existingInstallationDir=/mnt/Sonarqube Software
sys.confirmedUpdateInstallationString=false
sys.languageId=en
sys.installationDir=/mnt/atlassian/Sonarqube
executeLauncherAction$Boolean=true
httpPort$Long=8080
portChoice=default
EOF
# Installing Sonarqube with response.varfile
sudo ./atlassian-Sonarqube-software-8.1.0-x64.bin -q -varfile response.varfile
```

#### Set permissions for Sonarqube user 

```
# Setting user Sonarqube for Sonarqube home.
echo "Stopping Sonarqube"
sudo /etc/init.d/Sonarqube stop
sudo usermod -u 1088 Sonarqube
sudo groupmod -g 1088 Sonarqube
echo "Changing Owner to Sonarqube"
sudo chown -R Sonarqube:Sonarqube /mnt/Sonarqube_HOME
sudo chown -R Sonarqube:Sonarqube /mnt/atlassian/Sonarqube
echo "Starting Sonarqube"
sudo /etc/init.d/Sonarqube start
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
