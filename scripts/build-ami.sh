#!/usr/bin/env bash
# Script that starts Packer build, grabs AMI_ID and passes it along further
# to be reused by tests, generate a unique identified for this build.
# using uuidgen, as it is the one pre-0installed in systems, not uuid
UUID=$(uuidgen)

# Pass the unique identifier to packer as a user variable
packer build -var build_uuid=${UUID} -force nginx-aws-template.json

# grep AMI_ID from AWS CLI
AMI_ID=$(aws ec2 describe-images --filters Name=tag:PackerBuildUUID,Values=${UUID} --output text --query 'Images[0].ImageId')

echo ${AMI_ID}