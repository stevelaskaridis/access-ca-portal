# access-ca-portal

## Ansible

Ansible is an agentless system for app deployment, configuration management and orchestration.

We are using its powers to automatically set-up and deploy a new access-ca-portal instance.

## Prerequisites

On the **machine running the playbook**:
* Python
* Ansible 1.9
* SSH Access to the deployment machine

On the **deployment machine**:
* Python 2.4 or higher (Python2 at the moment)

More information about Ansible requirements can be found [here](http://docs.ansible.com/ansible/intro_installation.html).

### Memory requirements for passenger

In order to be able to run passenger with httpd, the machine must have at least 1GB of memory.
You can create a swap partition as follows:
```bash
sudo dd if=/dev/zero of=/swap bs=1M count=1024

sudo mkswap /swap

sudo swapon /swap

```

More information can be found [here](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/3/html/System_Administration_Guide/s1-swap-adding.html).

## Run ansible playbook

The wrapper playbook for all the application and its requirements is **ansible/playbooks/access.yml** which includes the relevant roles.

First, make sure you append the target machine hostname or ip inside the **ansible/playbooks/production** file.

To run the playbook, type the following command:
```
  ansible-playbook -v playbooks/access.yml
```

You can also specify task groups to run, by using the `--tags tag0,tag1,...`.
