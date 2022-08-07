#!/bin/bash
#!/bin/bash
if [ $(id -u) -ne 0 ]; then
  echo "Run this with root privilege"
  exit -1
fi
if [ $# -ne 1 ]; then
  echo "Usage: $0 <admin username>"
  exit -1
fi

ADMIN_USER=$1
ADMIN_KUBE_DIR=$(cat /etc/passwd | grep $ADMIN_USER | sed 's/::/:?:/g' | tr ':' ' ' | awk '{ print $6 }')/.kube

kubeadm reset
rm -rf /etc/cni/net.d
rm -rf /root/.kube
rm -rf $ADMIN_KUBE_DIR
