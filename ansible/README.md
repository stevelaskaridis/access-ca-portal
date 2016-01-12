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

The playbook for the application and all its requirements is [ansible/access.yml](access.yml) which includes the relevant roles.

First, make sure you specify the target machine hostname or IP in the [ansible/production](production) inventory file.

To run the playbook, type the following command:

    ansible-playbook -v ansible/access.yml


You can also specify task groups to run, by using the `--tags tag0,tag1,...`.

## Seeding data

After running the ansible playbook, there is one more step to take, before running your application; seeding initial data to your database.

The aforementioned can be accomplished by running the following command:

    rake db:seed

from the [access/](../access) directory.
