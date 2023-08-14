#!/bin/bash

# Move the files downloaded from the RedHat Cluster Manager site to the ocp-svc node
scp ~/Downloads/openshift-install-linux.tar.gz ~/Downloads/openshift-client-linux.tar.gz ~/Downloads/rhcos-metal.x86_64.raw.gz root@{ocp-svc_IP_address}:/root/

# Update the system packages
sudo yum update -y

# Add the OpenShift repository
sudo sh -c 'cat > /etc/yum.repos.d/openshift.repo <<EOF
[openshift]
name=OpenShift
baseurl=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-gpg-key.pub
EOF'

# Install OpenShift CLI (oc)
sudo yum install -y openshift-client

# Configure the OpenShift node using the cluster's API URL and token
CLUSTER_API_URL="https://api.cluster.example.com:6443"
CLUSTER_TOKEN="your_cluster_token"

sudo oc login --token=${CLUSTER_TOKEN} --server=${CLUSTER_API_URL}

# Label the node as a service node
sudo oc label node $(hostname) node-role.kubernetes.io/service=true

# Configure the node network interfaces
# Replace ethX and IP_ADDRESS with actual interface and IP address
INTERFACE_NAME="eth0"
IP_ADDRESS="192.168.1.10"
NETMASK="255.255.255.0"
GATEWAY="192.168.1.1"

sudo nmcli connection add type ethernet con-name ${INTERFACE_NAME} ifname ${INTERFACE_NAME} ip4 ${IP_ADDRESS}/${NETMASK} gw4 ${GATEWAY}
sudo nmcli connection modify ${INTERFACE_NAME} ipv4.method manual
sudo nmcli connection up ${INTERFACE_NAME}

# Configure DNS resolution
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

# Disable SELinux (optional, based on your security policies)
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# Disable firewalld (optional, based on your security policies)
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Reboot the server to apply changes
sudo reboot
