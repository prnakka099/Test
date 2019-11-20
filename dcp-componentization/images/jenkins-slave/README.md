# Aamazon Machine Image (AMI) Creation for Jenkins Slave Using Packer

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

**Install updates with _yum_ and _amazon-linux-extras_**  
  
This installs   
**Linux updates**  
**docker**  
**ansible** and other basic tools for linux

```
"sudo yum update -y",
"sudo yum install git -y",
"sudo yum install jq telnet git ntpdate ntp gcc gcc-c++ make openssl-devel expat-devel -y",
"sudo yum groupinstall 'Development Tools' -y",
"sudo amazon-linux-extras install ansible2 docker -y",
"sudo chkconfig docker on", 
"sudo usermod -a -G docker $USER",
"sudo service docker start",
```     

**Install Pip**

```
{
"aws --version",
"curl -O https://bootstrap.pypa.io/get-pip.py",
"python get-pip.py --user",
"echo \"export PATH=~/.local/bin:$PATH\" | tee --append /home/ec2-user/.bashrc", 
"source ~/.bashrc",
"pip --version",
}
```

**Install Nodejs**

```
"wget http://nodejs.org/dist/v8.12.0/node-v8.12.0-linux-x64.tar.gz",
"sudo tar --strip-components 1 -xzvf node-v* -C /usr/local",
"sudo ln -s /usr/local/bin/node /usr/bin/node",
"sudo ln -s /usr/local/lib/node /usr/lib/node",
"sudo ln -s /usr/local/bin/npm /usr/bin/npm",
"node --version",
```

**Install Kubectl**
```
"curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl",
"chmod +x ./kubectl",
"sudo cp ./kubectl /usr/local/bin/kubectl && export PATH=/usr/local/bin:$PATH",
"echo \"export PATH=/usr/local/bin:$PATH\"| tee --append /home/ec2-user/.bashrc",
"kubectl version --short --client",
```

**Install AWS IAM Authenticator**

```
"curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator", 
"chmod +x ./aws-iam-authenticator",
"sudo cp ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && export PATH=/usr/local/bin:$PATH",
"echo \"export PATH=/usr/local/bin/bin:$PATH\" | tee --append /home/ec2-user/.bashrc",
"aws-iam-authenticator help",
```

**Install Maven**
```
 "sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo",
"sudo sed -i s/\\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo",
"sudo yum install -y apache-maven",
"mvn --version"
```

## Command to run script

### To validate scripts

```
packer validate build.json
```

### To build an image
```
packer build build.json
```