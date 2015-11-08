# Access CA Portal [![Build Status](http://jenkins.admin.grnet.gr/job/access-ca-portal_devel/badge/icon)](https://jenkins.admin.grnet.gr/job/access-ca-portal_devel)

## Overview

Access CA portal is a Ruby on Rails application created to support the users' authenticated registration and x509 personal and hosts' certificate issuance.

## Setup guide

> The following setup guide is aimed for a CentOS 7 installation. However, with not too much effort, it can be adjusted to other Linux distributions as well.

### Software Stack

| Software Element | Version |
|---|---|
| OS  | CentOS 7  |
| Ruby  | 2.2.3  |
| Rails | 4.2.4  |
| PostgreSQL  | 9.2  |
| WebServer | Apache 2.4.6 |
| MailServer | Postfix 2.10.1 |

### Setup process

The project comes with an ansible installation process, which is responsible for installing and deploying an access-ca-portal instance.

In order to run the ansible playbook, move to the **ansible/** directory and follow the process described in the relevant documentation.
