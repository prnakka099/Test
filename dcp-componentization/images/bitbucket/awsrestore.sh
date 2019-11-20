#!/bin/bash

BITBUCKET_HOME=$1

mkdir -p /tmp/varun/bitbucket
mv -v ${BITBUCKET_HOME}/* /tmp/varun/bitbucket/

AWS_INFO="$(curl -L -s -f http://169.254.169.254/latest/dynamic/instance-identity/document)"
AWS_ACCOUNT_ID="$(echo "${AWS_INFO}" | jq -r .accountId)"
AWS_AVAILABILITY_ZONE="$(echo "${AWS_INFO}" | jq -r .availabilityZone)"
AWS_REGION="$(echo "${AWS_INFO}" | jq -r .region)"
AWS_EC2_INSTANCE_ID="$(echo "${AWS_INFO}" | jq -r .instanceId)"

echo "EC2 Region ID : ${AWS_REGION}"
echo "EC2 Instance Id : ${AWS_EC2_INSTANCE_ID}" > /tmp/varun/ec2id

# GEt the latest snapshot id
echo "Finding the Latest Snapshot"

BB_SNAPSHOT_ID="$(aws ec2 describe-snapshots --owner self \
--filter Name=tag:Name,Values=DCP-Bitbucket-HomeDirData-* \
--query "sort_by(Snapshots, &StartTime)[-1].SnapshotId" \
--output text --region ${AWS_REGION})"

echo "Snapshot ID to restore from : ${BB_SNAPSHOT_ID}"

BB_NO_SNAPSHOT="None"
echo "BB_NO_SNAPSHOT : ${BB_NO_SNAPSHOT}"

# Create the EBS Volume from the snapshot id
echo "Creating the EBS Volume"

if [ "${BB_NO_SNAPSHOT}" == "${BB_SNAPSHOT_ID}" ]; then
echo "Creating the EBS Volume without snapshot, so first time"
aws ec2 create-volume --size 40 --region ${AWS_REGION} --availability-zone ${AWS_AVAILABILITY_ZONE} --volume-type gp2 \
--tag-specifications 'ResourceType=volume,Tags=[{Key=purpose,Value=Bitbucket Data Volume},{Key=Name,Value=DCP-Bitbucket-EBS}]' \
--encrypted --kms-key-id "arn:aws:kms:us-east-1:551061066810:key/982bd5de-0a08-4ee6-8a01-cd4f7172436a"
else
echo "Creating the EBS Volume from Snapshot : ${BB_SNAPSHOT_ID}"
aws ec2 create-volume --size 40 --region ${AWS_REGION} --availability-zone ${AWS_AVAILABILITY_ZONE} --volume-type gp2 \
--snapshot-id ${BB_SNAPSHOT_ID} \
--tag-specifications 'ResourceType=volume,Tags=[{Key=purpose,Value=Bitbucket Data Volume},{Key=Name,Value=DCP-Bitbucket-EBS}]' \
--encrypted --kms-key-id "arn:aws:kms:us-east-1:551061066810:key/982bd5de-0a08-4ee6-8a01-cd4f7172436a"
fi

sleep 30s

#Get the Volume ID
echo "Finding the Volume Id just created"

EBS_VOLUME_ID="$(aws ec2 describe-volumes \
--filter "Name=availability-zone,Values=${AWS_AVAILABILITY_ZONE}" "Name=tag:Name,Values=DCP-Bitbucket-EBS" \
--query "sort_by(Volumes, &CreateTime)[-1].VolumeId " \
--output text --region ${AWS_REGION})"
echo "Volume ID to be attached : ${EBS_VOLUME_ID}"

# Attach the EBS Volume to the EC2
echo "Attaching the EBS Volume to the EC2 Instance"
aws ec2 attach-volume --volume-id ${EBS_VOLUME_ID} --instance-id ${AWS_EC2_INSTANCE_ID} --device /dev/sdf --region ${AWS_REGION}
sleep 30s

#Check if making file system is required or not.
FILE_SYS="$(sudo file -s /dev/nvme1n1)"
echo "FILE System : ${FILE_SYS}"

if sudo file -s /dev/nvme1n1 | grep XFS; then 
echo "Filesystem Already Exists"
else
sudo mkfs -t xfs /dev/nvme1n1
echo "Filesystem created"
fi

sudo mount /dev/sdf ${BITBUCKET_HOME}

if grep "${BITBUCKET_HOME}" /etc/fstab
then
    echo "Bitbucket Entry in fstab exists"
else
    echo "Bitbucket Entry in fstab do not exist, Adding entry"
    echo "#Bitbucket Data disk" >> /etc/fstab
    echo "/dev/sdf ${BITBUCKET_HOME} xfs defaults,nofail 0 2" >> /etc/fstab
fi

if [ "$(ls -A ${BITBUCKET_HOME})" ]; then
    echo "${BITBUCKET_HOME} Is Not Empty"
else
    echo "${BITBUCKET_HOME} is Empty"
    mv -v /tmp/varun/bitbucket/* ${BITBUCKET_HOME}/
fi

echo "Done with configuring BITBUCKET_HOME"