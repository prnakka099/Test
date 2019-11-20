# Aamazon Machine Image (AMI) with Ubuntu Creation for selenium Node Using Packer

Hashicorp Packer is used to build Amazon Machine Images based on the defined configuration.

## Installation

**Amazon Base AMI Used :** Ubuntu

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
| ssh_username      |               | Packer uses ubuntu as the user to install tools on EC2                                   |
| kms_key_id        |               | KMS Key to be used to encrypt the final AMI                                                |

#### Install Ubuntu Updates and Selenium Node

```
"sudo apt-get update -y",
"sudo apt-get install -y unzip xvfb libxi6 libgconf-2-4",
"sudo add-apt-repository ppa:openjdk-r/ppa -y",
"sudo apt-get install openjdk-8-jdk -y",
"sudo wget https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz",
"sudo tar -xvf geckodriver-v0.19.1-linux64.tar.gz",
"sudo mv geckodriver /usr/local/bin/",
"sudo apt install firefox -y",
"sudo wget http://selenium-release.storage.googleapis.com/3.10/selenium-server-standalone-3.10.0.jar"


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
