FROM quay.io/centos/centos:stream9

MAINTAINER ZHL Zack

ENV container=docker

# Upgrade / update
RUN yum update -y && \
    yum upgrade --setopt=install_weak_deps=False -y

RUN yum install -y sudo \
        wget \
        patch \
        centos-release \
        epel-release \
        rpm \
        dnf-plugins-core \
        which \
        hostname \
        libyaml \
        python3 \
        python3-pip \
        python3-pyyaml && \
    yum clean all 

# Setup Systemd
RUN yum -y install systemd ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i ; done ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Upgrade pip
RUN pip3 install --upgrade pip
# Install ansible through pip
RUN pip3 install ansible

# Install Ansible Inventory File
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Cleanup
RUN rm -rf /tmp/* && \
    rm -rf /var/cache/yum && \
    rm -rf /var/cache/dnf

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init"]