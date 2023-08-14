#!/bin/bash

### Run the commamd line below from your Laptop
### scp -i .ssh/id_rsa2 ~/Downloads/rhcos* ~/Downloads/openshift* ~/Downloads/pull-secret root@158.176.4.92:/root/

# Install Subscription Manager
dnf install subscription-manager

# Update the system packages
sudo dnf update -y

# Extract Client tools and copy them to /usr/local/bin
tar xvf openshift-client-linux.tar.gz
mv oc kubectl /usr/local/bin

# Extract the OpenShift Installer
tar xvf openshift-install-linux.tar.gz

# Install Git
dnf install git -y

# Download the config files
git clone https://github.com/FrederikAouizerats/ocp-VPCBMESXi.git