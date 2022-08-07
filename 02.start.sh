#!/bin/bash
cd $(dirname ${BASH_SOURCE[0]})

if [ $(id -u) -ne 0 ]; then
  echo "Run this with root privilege"
  exit -1
fi
if [ $# -lt 2 ]; then
  echo "Usage: $0 <admin username> <api-server advertise address 1> {api-server advertise address 2 ...}"
  exit -1
fi

ARG_COUNT=$#
ADMIN_USER=$1
ADDR=$2
ADMIN_KUBE_DIR=$(cat /etc/passwd | grep $ADMIN_USER | sed 's/::/:?:/g' | tr ':' ' ' | awk '{ print $6 }')/.kube

INIT_COMMAND="kubeadm init --cri-socket=unix:///var/run/containerd/containerd.sock --pod-network-cidr=10.100.0.0/17 --service-cidr=10.100.128.0/17 --kubernetes-version v1.24.3 --apiserver-advertise-address $ADDR"
if [ $# -gt 2 ]; then
  INIT_COMMAND="$INIT_COMMAND --apiserver-cert-extra-sans="
	for i in $(seq 3 $ARG_COUNT); do
		if [ $i -gt 3 ]; then
			INIT_COMMAND="$INIT_COMMAND,"
		fi
		INIT_COMMAND="${INIT_COMMAND}$(echo $@ | awk '{ print $'$i' }')"
	done
fi
$($INIT_COMMAND)

mkdir -p /root/.kube
mkdir -p $ADMIN_KUBE_DIR
cp -f /etc/kubernetes/admin.conf /root/.kube/config
cp -f /etc/kubernetes/admin.conf $ADMIN_KUBE_DIR/config
chown $ADMIN_USER: $ADMIN_KUBE_DIR/config

kubectl taint nodes $(cat /etc/hostname) node-role.kubernetes.io/master-
kubectl taint nodes $(cat /etc/hostname) node-role.kubernetes.io/control-plane-

curl https://docs.projectcalico.org/manifests/calico.yaml -O --insecure
kubectl apply -f calico.yaml
chown $ADMIN_USER: calico.yaml
