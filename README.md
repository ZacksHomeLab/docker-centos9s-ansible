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
docker run -d --privileged -ti --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro docker-centos9s-ansible:latest
```

# How-To Run the Image in Molecule
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

* Within the root of your project, run the following:
```
molecule converge
```

# Notes
This image is for TESTING PURPOSES ONLY!!
