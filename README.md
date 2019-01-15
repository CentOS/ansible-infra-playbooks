# CentOS.org Ansible Infra playbooks

Just a placeholder for the Ansible playbooks used in the CentOS Infrastructure.
Mainly divided into :

 * playbooks only including role (and so applied based on group membership)
 * ad-hoc tasks playbooks, called on demand when needed

##  Naming convention
The playbooks that will be played for roles will start with `role-<role_name>`
A all-in-one infra.yml will just include all the role-<role_name>.yml when we want to just ensure the whole infra is configured the way it should.

All other ad-hoc playbooks can just be named/start with `adhoc-<function>`.
Those specific playbooks can need some tasks/vars/handlers, so for those special ones (as each role has it own set) we'll include those in the same repository, but it's up to the process deploying those for the ansible-host role to setup correctly the needed symlinks for the normal hierarchy.

The "on-disk" ansible directory should then look like this :

```
.
├── ansible.cfg
├── files -> playbooks/files
├── handlers -> playbooks/handlers
├── filestore
├── inventory
├── pkistore
├── playbooks
│   ├── files
│   ├── handlers
│   ├── requirements.yml
│   └── vars
│   └── templates
├── roles
│   ├── <role-name>
└── templates -> playbooks/templates
└── vars -> playbooks/vars

```

## Ansible roles setup
All roles will be deployed for a list of individual git repositories, each one being its own role.
A requirements.yml file will be used to declare which roles (and from where to get them) and so downloaded on the ansible host through ansible-galaxy

## Inventory and encrypted files
Inventory is itself a different git repository, git-crypted and that will be checked-out on the ansible host
Same for the two following git (crypted) repositories:
 * pkistore (holding some PKI key/certs)
 * filestore (holding some other files/secrets that aren't templates but that should be crypted/non public, so not in roles either)
