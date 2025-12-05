#!/bin/bash
# This script bootstraps an EC2 instance by updating the OS, installing and starting the Apache web server,
# enabling it to run on startup, and creating a simple homepage that displays the instance's hostname 
# and availability zone. This demonstrate multi-AZ deployment by showing which AZ serves the webpage.
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Multi-AZ App $(hostname) - $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</h1>" > /var/www/html/index.html
