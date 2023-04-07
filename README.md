# Centos 9 Stream Ansible Test Image
CentOS 9 Stream Docker container for Ansible playbook and role testing.

# How-To Build Image from Dockerfile
* Download the Dockerfile onto your machine that has docker installed. 
* Run the following command to build the image:
```
docker build -t docker-centos9s-ansible:latest .
```

# How-To Run the Image
* Once the image has been built, create a container by running the following command:
```
docker run --detach --privileged --cgroupns=host -ti --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro docker-centos9s-ansible:latest
```

# How-To Run Image in Molecule

NOTE: For individuals using WSL2 (Ubuntu 20.04), you may need to run the following commands on your WSL2 instance to get systemd to work:

```
sudo apt-get update && sudo apt-get install -yqq daemonize dbus-user-session
sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
exec sudo nsenter -t $(pidof systemd) -a su - $LOGNAME
```

* Here's an example of a `molecule.yml` file to test the image with your ansible playbooks/roles:
```
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance-1-centos9s
    image: docker-centos9s-ansible:latest
    command: ${MOLECULE_DOCKER_COMMAND:-"/usr/sbin/init"}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
provisioner:
  name: ansible
  config_options:
    defaults:
      remote_tmp: /tmp
verifier:
  name: ansible
```

* With `molecule.yml` configured, run your molecule converge playbook by running the following command:
```
molecule converge
```

# Notes
This image is for TESTING PURPOSES ONLY!!
