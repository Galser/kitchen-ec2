#!/usr/bin/env bash
# Script that starts Packer build, grabs AMI_ID from manifest
# and injects it into .kitchen.yml to be reused by tests

# Build AMI while outputting manifest into current dir
packer build -force nginx-aws-template.json

# grep AMI_ID from Pakcer's manifest
AMI_ID=$(grep artifact_id manifest.json | grep -o -E 'ami-.{17}')

# Generate KitchenCI config
cat > .kitchen.yml << EOL
---
driver:
  name: ec2
  region: eu-central-1

provisioner:
  name: shell

platforms:
  - name: ubuntu-16.04
    driver:
      image_id: ${AMI_ID}
    transport:
      username: ubuntu

verifier:
  name: inspec

suites:
  - name: default

EOL