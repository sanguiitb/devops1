#!/bin/bash

#AWS Url for metadata,Can be used in user-data for autoscaling, adding just for sake for noting it down
INST_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo "Enter the Instance ID to be tagged"
read instance_id

#Tag Elastic IP
ALLOCATION_ID=$(aws ec2 describe-addresses --region  us-west-2 --filters Name=instance-id,Values=$instance_id| jq -r '.Addresses[].AllocationId' )

#Tag All the Volumes for each instance
ROOT_DISK_ID=$(aws ec2 describe-volumes --region us-west-2 --filters Name=attachment.instance-id,Values=$instance_id --query "Volumes[*].{ID:VolumeId}" --out text)

LOG_DISK_ID=$(aws ec2 describe-volumes --region us-west-2 \
  --filters Name=attachment.instance-id,Values=$instance_id Name=attachment.device,Values=/dev/sdb | \
  jq -r '.Volumes[].VolumeId')
  
aws ec2 create-tags --resources $ROOT_DISK_ID $ALLOCATION_ID $LOG_DISK_ID --tags Key=customer:environment,Value=dev \
    Key=customer:other:product,Value=hal \
    Key=customer:other:vendor,Value=hal \
    Key=customer:other:deployment,Value=auto \
    Key=customer:other:role,Value=auto --region us-west-2
