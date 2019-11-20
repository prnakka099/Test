#! /bin/bash
# Updating the instance
sudo yum update -y
# Installing nfs tools
sudo yum -y install nfs-utils
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