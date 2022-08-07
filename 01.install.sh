#!/bin/bash
if [ $# -ne 0 ] && [ $(echo $1 | grep -E '(--help)|(-h)' | wc -l) -eq 1 ]; then
	echo "Usage: $0 {alias for kubectl}"
	exit 0
fi
if [ $(id -u) -ne 0 ]; then
  echo "Run this with root privilege"
  exit -1
fi

pacman -S kubelet kubectl kubeadm cni-plugins crictl ethtool socat containerd bash-completion
systemctl enable kubelet
systemctl enable containerd

mkdir -p /etc/bash_completion.d/
kubectl completion bash | tee /etc/bash_completion.d/kubectl
if ! [[ $1 == "" ]]; then
	ALIAS=$1
  kubectl completion bash | tee /etc/bash_completion.d/$ALIAS
	sed -i "s/kubectl/$ALIAS/g" /etc/bash_completion.d/$ALIAS
fi

# systemd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ipforward = 1
net.bridge.bridge-nf-call.ip6tables = 1
EOF

sysctl --system

mkdir -p /etc/containerd
contaienrd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
