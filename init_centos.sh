#!/bin/bash

pushd /etc/yum.repos.d
    echo "rm default repo"
    rm -rf ./*.repo
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum makecache fast
popd