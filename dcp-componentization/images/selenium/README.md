# Aamazon Machine Image (AMI) Creation for selenium Using Packer

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

#### Install selenium

```
#!/bin/bash
#new isntallation dierectory for selenium
sudo yum install -y java-1.8.0
wget http://selenium-release.storage.googleapis.com/3.10/selenium-server-standalone-3.10.0.jar
java -jar selenium-server-standalone-3.10.0.jar -role hub

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
