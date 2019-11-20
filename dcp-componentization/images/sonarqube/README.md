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
# Installing Ansible
sudo amazon-linux-extras install ansible2 -y
# Installing Java
sudo yum install java-1.8.0 -y
# Installing nfs tools
sudo yum -y install nfs-utils
```     

#### Install Sonarqube 

```
# Installing sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip
sudo unzip sonarqube-7.6.zip -d /mnt/sonar
```

#### Set permissions for Sonarqube user 

```
sudo groupadd sonar
sudo useradd -c "Sonar System User" -d /mnt/sonar -g sonar -s /bin/bash sonar
sudo chown -R sonar:sonar /mnt/sonar
```

#### Uploading anisble/confirure.yml file to /tmp/configure.yml which will configure the sonar.properties files at runtime with DB Details, Web Context and Also set RUN_AS_USER value to sonar in sonar.sh file to run the services as sonar and not root.
```
{
        "type": "file",
        "source": "ansible/configure.yml",
        "destination": "/tmp/configure.yml"
}
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
