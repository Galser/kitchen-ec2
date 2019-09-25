#!/usr/bin/env bash
# Nginx provision script for Ubunt 18.04 Bionic Beaver

# wait
sleep 30

# Install NGinx
sudo apt update
sudo apt install -y nginx

# Nginx is going to register isteslf in UFW as service
# But we still need to enable it
sudo ufw allow 'Nginx HTTP'
