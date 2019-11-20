# Aamazon Machine Image (AMI) Creation for Confluence Using Packer

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

#### Install Confluence

```
sudo wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.15.1-x64.bin
sudo chmod a+x atlassian-confluence-6.15.1-x64.bin
sudo cat > response.varfile <<- "EOF"
# install4j response file for Confluence 6.15.1
app.confHome=/mount/atlassian/application-data/confluence
app.install.service$Boolean=true
existingInstallationDir=/opt/Confluence
launch.application$Boolean=true
portChoice=default
sys.adminRights$Boolean=true
sys.confirmedUpdateInstallationString=false
sys.installationDir=/opt/atlassian/confluence
sys.languageId=en
EOF
sudo ./atlassian-confluence-6.15.1-x64.bin -q -varfile response.varfile
```


## Command to run script

To validate scripts

```
packer validate confluence-build.json
```

To build an image
```
packer build confluence-build.json
```
