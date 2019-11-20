#! /bin/bash
# Updating the instance
sudo yum update -y
# Installing nfs tools
sudo yum -y install nfs-utils
# Making home directory for JIRA
sudo mkdir -p /mnt/JIRA_HOME
# Getting JIRA package
sudo wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.1.0-x64.bin
#
sudo chmod a+x atlassian-jira-software-8.1.0-x64.bin
#
sudo cat > response.varfile <<- "EOF"
#install4j response file for JIRA Software 8.1.0
#Mon Apr 08 16:11:15 UTC 2019
launch.application$Boolean=true
rmiPort$Long=8005
app.jiraHome=/mnt/JIRA_HOME
app.install.service$Boolean=true
existingInstallationDir=/opt/JIRA Software
sys.confirmedUpdateInstallationString=false
sys.languageId=en
sys.installationDir=/opt/atlassian/jira
executeLauncherAction$Boolean=true
httpPort$Long=8080
portChoice=default
EOF
# Installing JIRA with response.varfile
sudo ./atlassian-jira-software-8.1.0-x64.bin -q -varfile response.varfile
# Setting user jira for JIRA home.
echo "Stopping Jira"
sudo /etc/init.d/jira stop
sudo usermod -u 1088 jira
sudo groupmod -g 1088 jira
echo "Changing Owner to jira"
sudo chown -R jira:jira /mnt/JIRA_HOME
sudo chown -R jira:jira /opt/atlassian/jira
echo "Starting JIRA"
sudo /etc/init.d/jira start
