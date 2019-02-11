#!/bin/bash

# disable firewall
ufw disable

# install awscli and get content
apt-get update
apt-get install awscli -y
aws s3 cp s3://clearscore-website/ /var/www/html --recursive

# install nginx
apt-get install nginx -y
systemctl enable nginx
systemctl start nginx