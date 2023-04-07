FROM quay.io/centos/centos:stream9

MAINTAINER ZHL Zack

# Upgrade / update
RUN dnf update -y && \
    dnf upgrade --setopt=install_weak_deps=False -y

RUN dnf install -y sudo \
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
    dnf clean all 

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