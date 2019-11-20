#updating the instance
sudo yum update -y
#
#Installing the git
sudo yum install -y git
#
#Installing the jq
sudo yum install -y jq
sudo mkdir -p /mnt/atlassian/bb_home

sudo wget https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-6.2.0-x64.bin
#
sudo chmod +x atlassian-bitbucket-6.2.0-x64.bin
#
sudo cat > response.varfile <<- "EOF"
#install4j response file for BitBucket Software 6.2.0
#Mon Apr 28 16:11:15 UTC 2019
app.install.service$Boolean=true
app.bitbucketHome=/mnt/atlassian/bb_home
EOF
sudo ./atlassian-bitbucket-6.2.0-x64.bin -q -varfile response.varfile