#!/bin/bash

AWS_INFO="$(curl -L -s -f http://169.254.169.254/latest/dynamic/instance-identity/document)"
AWS_REGION="$(echo "${AWS_INFO}" | jq -r .region)"
AWS_EC2_INSTANCE_ID="$(echo "${AWS_INFO}" | jq -r .instanceId)"

volume_id="$(aws ec2 describe-volumes \
--filters Name=attachment.status,Values=attached Name=tag:Name,Values=DCP-Bitbucket-EBS Name=attachment.device,Values=/dev/sdf \
--query "Volumes[].Attachments[].VolumeId" --output text --region ${AWS_REGION})"

echo "Volume ID: ${volume_id}"

instance_id="$(aws ec2 describe-volumes \
--volume-ids ${volume_id} --query "Volumes[].Attachments[].InstanceId" --output text --region ${AWS_REGION})"

echo "Attached to Instance with Id: ${instance_id}"

inst_name="$(aws ec2 describe-tags \
--filters Name=resource-id,Values=${instance_id} Name=key,Values=Name \
--query "Tags[].Value" --output text --region ${AWS_REGION})"

echo "Instance Name : ${inst_name}"

block="$(aws ec2 describe-volumes --volume-ids $volume_id --query "Volumes[].Attachments[].Device" \
--output text --region ${AWS_REGION})"

echo "Block Device Name for the Instance : ${block}"

snapid="$(aws ec2 create-snapshot \
--volume-id ${volume_id} --query "SnapshotId" \
--description "Automated-SnapShot-${inst_name}-${block}" \
--output text --region ${AWS_REGION})"

echo "Snapshot ID : ${snapid}"

aws ec2 create-tags --resources ${snapid} --tags Key=Name,Value=DCP-Bitbucket-HomeDirData-`date +%Y-%b-%d_%H:%M:%S` \
--region ${AWS_REGION}

echo "Tags Added"