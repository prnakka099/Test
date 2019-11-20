# Aamazon Machine Image (AMI) Creation for Jenkins Master Using Packer

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

**Install updates with _yum_ and _amazon-linux-extras_ **
This installs Linux updates, amazon-efs-utils, ansible and other basic tools for linux

```
"sudo yum update -y",
"sudo yum install git -y",
"sudo yum install amazon-efs-utils jq ntpdate ntp gcc openssl-devel expat-devel -y",
"sudo yum groupinstall 'Development Tools' -y",
"sudo amazon-linux-extras install ansible2 -y"
```     

** Install Java and Jenkins with Ansible **

```
{
        "type": "ansible-local",
        "playbook_file": "ansible/playbook.yml",
        "playbook_dir": "ansible",
        "command": "ansible-playbook",
        "galaxycommand": "ansible-galaxy"
}
```

** Set permissions for Jenkins user **

```
 {
        "type": "shell",
        "inline": [
            "sudo service jenkins stop",
            "sudo usermod -u 1088 jenkins",
            "sudo groupmod -g 1088 jenkins",
            "sudo mkdir -p /var/log/jenkins",
            "sudo mkdir -p /var/lib/jenkins",
            "sudo mkdir -p /var/cache/jenkins",
            "sudo mkdir -p /var/run/jenkins",
            "sudo chown -R jenkins:jenkins /mnt/JENKINS_HOME",
            "sudo chown -R jenkins:jenkins /var/log/jenkins",
            "sudo chown -R jenkins:jenkins /var/lib/jenkins",
            "sudo chown -R jenkins:jenkins /var/cache/jenkins",
            "sudo chown -R jenkins:jenkins /var/run/jenkins",
            "sudo service jenkins start"
        ]
    }
```

** Install Cloudwatch Agent **
```
{
        "type": "shell",
        "inline": [
            "ls -alr /tmp/",
            "wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm",
            "sudo rpm -U ./amazon-cloudwatch-agent.rpm",
            "sudo mv -f -b /tmp/file-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/file-cloudwatch-agent.json",
            "sudo chown root:root /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/file-cloudwatch-agent.json"
        ]
    },
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
