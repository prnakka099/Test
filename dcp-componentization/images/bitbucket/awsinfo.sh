#!/bin/bash
ebs_id=$1
BITBUCKET_HOME=$2
region=$3

mkdir -p /tmp/varun/bitbucket
mv -v ${BITBUCKET_HOME}/* /tmp/varun/bitbucket/

AWS_INFO="$(curl -L -s -f http://169.254.169.254/latest/dynamic/instance-identity/document)"
AWS_ACCOUNT_ID="$(echo "${AWS_INFO}" | jq -r .accountId)"
AWS_AVAILABILITY_ZONE="$(echo "${AWS_INFO}" | jq -r .availabilityZone)"
AWS_REGION="$(echo "${AWS_INFO}" | jq -r .region)"
AWS_EC2_INSTANCE_ID="$(echo "${AWS_INFO}" | jq -r .instanceId)"

echo "EBS Volume Id : ${ebs_id}" > /tmp/varun/ebsid
echo "EC2 Instance Id : ${AWS_EC2_INSTANCE_ID}" >/tmp/varun/ec2id

aws ec2 attach-volume --volume-id ${ebs_id} --instance-id ${AWS_EC2_INSTANCE_ID} --device /dev/sdf --region ${region}
sleep 2m

#Check if making file system is required or not.
if sudo file -s /dev/nvme1n1 | grep XFS; then 
echo "Filesystem Already Exists"
else
sudo mkfs -t xfs /dev/nvme1n1
echo "Filesystem created"
fi

sudo mount /dev/sdf ${BITBUCKET_HOME}

if [ "$(ls -A ${BITBUCKET_HOME})" ]; then
    echo "${BITBUCKET_HOME} Is Not Empty"
else
    mv -v /tmp/varun/bitbucket/* ${BITBUCKET_HOME}/
fi

echo "Done with configuring BITBUCKET_HOME"