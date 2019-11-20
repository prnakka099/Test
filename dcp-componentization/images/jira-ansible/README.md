# Aamazon Machine Image (AMI) Creation for JIRA Using Packer

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


#### This installs Linux updates, amazon-efs-utils and ansible.

```
# Updating the instance
sudo yum update -y
# Installing nfs tools
sudo yum -y install nfs-utils
# Istalling Ansible
sudo amazon-linux-extras install ansible2 -y
```     

#### Install JIRA with Ansible

```
{
        "type": "ansible-local",
        "playbook_file": "ansible/playbook.yml",
        "playbook_dir": "ansible",
         "command":  "ansible-playbook",
         "galaxycommand": "ansible-galaxy"
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
