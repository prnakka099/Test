Steps to deploy Openshift on AWS

This cluster is consist of three nodes and according to the specifications I came up with the following configuration,

Master node (t2.xlarge, 30GB EBS)
Two worker nodes (t2.large, 30GB EBS)

To create ec3 instance we have come up with the script which will create instance with security groups & policies.

Replace AMI_ID and VPC_ID with correct values in the following Cloud formation and deploy. Please find the below link for scripts aws-instance-create


Once the Cloud formation stack is successfully deployed, get the following information,

Public Hostname of the Master node(public_hostname_master_node)
Private Hostname of all three node(private_hostname_worker_node_1, private_hostname_worker_node_2, private_hostname_master_node)
SSH key which is used for Cloud formation stack(ssh_key.pem)
Lay the Groundwork
We are going to run the Ansible scripts from the Master node. Let’s initiate an SSH connection to the Master node,
ssh -i ssh_key.pem centos@public_hostname_master_node

Create an Inventory file with the following content and replace private_hostname_worker_node_1, private_hostname_worker_node_2, private_hostname_master_node, public_hostname_master_node with correct values,


Inventory file


Htpasswd is used as the Identity provider and an user{Username: admin, Password: admin} is created with the openshift_master_htpasswd_users parameter. You can generate a new entry for a user from here.
Since satisfying the above requirements for each Instance manually, is not an efficient task, use below content and create prepare.yaml Ansible script to automate the installation,
Find the link for prapare.yaml
Next, let’s install a couple of tools only on the Master node,

Git
yum -y install git



Pip(In order to install a specific version of Ansible we need Pip)
yum install epel-release
yum -y install python-pip

Ansible(Version 2.6.5)
pip install ansible==2.6.5

Next clone the Openshift Ansible repository,

git clone https://github.com/openshift/openshift-ansible
cd openshift-ansible
Git checkout release-3.11

Installing……….

Make sure to initiate an SSH connection for all private hostname otherwise you’ll be asked to add these hostnames to Known hosts during the installation. Assuming you’re in the current directory structure,

.
├── inventory
├── openshift-ansible
├── prepare.yaml
└── ssh_key.pem

Run the prepare.yaml script,

ansible-playbook prepare.yaml -i inventory --key-file ssh_key.pem

2. Run Openshift ansible prerequisites.yml,

ansible-playbook openshift-ansible/playbooks/prerequisites.yml -i inventory --key-file ssh_key.pem

3. Deploy the cluster,

ansible-playbook openshift-ansible/playbooks/deploy_cluster.yml -i inventory --key-file ssh_key.pem


A tool called oc is installed on the master node with Cluster admin privileges which can be used to manage the cluster.

After a successful installation list the Openshift nodes in the cluster,

oc get nodes


You can use the following link to login into the cluster with Username=admin, Password=admin credentials,

https://public_hostname_master_node:8443/console




Known issues !!!!!
Once we execute cloudformation script for aws instance, set locale issue will come just  Execute this command  
EXPORT LANG=es_US.utf8

After moving required inventory and yaml files master node make sure you give 
chmod 400 to pem file


Change public host name with respective domains in inventory file

 Change yaml file please use provided yaml file which causes an for me
	

Change user to root and execute installation from master node
    
	

   
 
 
