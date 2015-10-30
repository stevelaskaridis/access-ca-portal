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

## Run ansible playbook

The wrapper playbook for all the application and its requirements is **ansible/playbooks/access.yml** which includes the relevant roles.

First, make sure you append the target machine hostname or ip inside the **ansible/playbooks/production** file.

To run the playbook, type the following command:
```
  ansible-playbook -v playbooks/access.yml
```

You can also specify task groups to run, by using the `--tags tag0,tag1,...`.