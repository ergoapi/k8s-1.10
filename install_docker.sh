#!/bin/sh
set -e

VERSION="17.05"


lsb_dist=""
if [ -r /etc/os-release ]; then
	lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

debian_install(){
    apt-get update
    apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) edge"
    apt-get update
    apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep $VERSION | tail -1 | awk '{print $3}')
    systemctl restart docker
}

ubuntu_install(){
    apt-get update
    apt-get install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) edge"
    apt-get update
    apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep $VERSION | tail -1 | awk '{print $3}')
    systemctl restart docker
}

centos_install(){
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum-config-manager --enable docker-ce-edge
    pkg_version=$(yum list --showduplicates 'docker-ce' | grep $VERSION | tail -1 | awk '{print $2}')
    yum install -y docker-ce-$pkg_version
}

case $lsb_dist in
    centos)
        centos_install
    ;;
    debian)
        debian_install
    ;;
    ubuntu)
        ubuntu_install
    ;;
    *)
        echo "not support"
    ;;
esac