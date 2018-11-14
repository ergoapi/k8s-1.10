#!/bin/sh
set -e

VERSION="1.10.9-0"

lsb_dist=""
if [ -r /etc/os-release ]; then
	lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

ubuntu_debian_install(){
    apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF  
    apt-get update
    apt-get install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION

}

centos_install(){
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
    setenforce 0
    yum install -y kubelet-$VERSION kubeadm-$VERSION kubectl-$VERSION
}

case $lsb_dist in
    centos)
        centos_install
    ;;
    debian)
        ubuntu_debian_install
    ;;
    ubuntu)
        ubuntu_debian_install
    *)
        echo "not support"
    ;;
esac