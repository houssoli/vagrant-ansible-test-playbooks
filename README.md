The repository contains the Ansible roles and playbooks used to fully configure my sample **Vagrant Ansible Test**'s infrastructure and services.

## Usage pattern of the Ansible playbooks, roles, inventories, group_vars and host_vars

```
$ mkdir -p ~/workspace
$ cd ~/workspace

$ git clone ssh://git@[REDACTED_GIT_REPO_PATH]/vagrant-ansible-test-playbooks.git
$ git clone ssh://git@[REDACTED_GIT_REPO_PATH]/vagrant-ansible-test-vars.git

$ tree -L 1 ~/workspace

├── vagrant-ansible-test-playbooks
└── vagrant-ansible-test-vars
```

Both repositories must be cloned at the same level because of the links between the two.

Note : 

The repository vagrant-ansible-test-vars.git will contain the "private" variables specific to infrastructure and environment inventories.


## Running playbooks

The playbooks are to be executed by being at the root of the vagrant-ansible-test-playbooks.git repository, ie according to the example above, ~/workspace/vagrant-ansible-test-playbooks/.

First you need to make sure you can access all machines (SSH fingerprint of the verified host, public key login, functional sudo password).
If everything is ok, the the following command should not return an error :

```
$ ansible -m ping all
```

Running the main playbook :

```
~/workspace/vagrant-ansible-test-playbooks$ ansible-playbook site.yml
```

You can add the -t (--tags) option to only play certain roles or tasks, or the -l (--limit) option to limit execution to only certain hosts. 

To know much more about the options at your disposal, run the following command:

```
$ ansible-playbook --help
```

### Download Ansible dependencies for Playbook

#### All dependencies
At root path:
```shell script
ansible-galaxy install -r ./vagrant-ansible-test-playbooks/*/requirements.yml -p ./roles -f
```

#### Specific dependencies
At root path:
```shell script
ansible-galaxy install -r ./vagrant-ansible-test-playbooks/commons/requirements.yml -p ./roles -f
```

### Run Ansible 

#### Playbook
At root path:
```shell script
ansible-playbook vdc1-ansible-playbook/commons/playbook.yml -i vagrant-ansible-test-vars/inventories/vagrant/inventory.yml
```

#### Test inventory configuration
At root path:
```shell script
ansible servers_group -m ping -i vagrant-ansible-test-vars/inventories/vagrant/inventory.yml
```

## Testing

### Test automatically using molecule

```shell script
molecule test --scenario-name [SCENARIO-NAME]
```

But some variables are encrypted using `ansible-vault` on the basis of a vault password, and will need to be recovered clearly.
Ansible provides specific environment variables that will make us to define the location of a file where is held the vault password,
so that the recovering of decrypted value of those variables will require to provide the vault password in a safe manner.

#### How to specify a vault password file to molecule test ?

* Using the ANSIBLE_VAULT_IDENTITY_LIST environment variable like so:

```shell script
ANSIBLE_VAULT_IDENTITY_LIST=dev@$HOME/.ansible/.deploy-dev.ansible.vaultpass molecule test --scenario-name [SCENARIO-NAME]
```
where [ANSIBLE_VAULT_IDENTITY_LIST](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_VAULT_IDENTITY_LIST) stands for the list of vault-ids to use by default (equivalent to multiple –vault-id args for Vault-ids to be tried in order),
will also bypass molecule arguments parsing logic and let ansible know where the vault passwords are located.


* OR by using the ANSIBLE_VAULT_PASSWORD_FILE environment variable like so:
```shell script
ANSIBLE_VAULT_PASSWORD_FILE=$HOME/.ansible/.deploy-dev.ansible.vaultpass molecule test --scenario-name [SCENARIO-NAME]
```
where [ANSIBLE_VAULT_PASSWORD_FILE](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE) stands for the vault password file to use. Equivalent to –vault-password-file or –vault-id,
and so, will bypass molecule arguments parsing logic and let ansible know where the vault password is located.

## Resources

* [Ansible User » Guide Working With Playbooks » Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
