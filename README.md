Windows Server 2016 DISA STIG image creation with Packer
=========
This project uses [Packer](https://www.packer.io/)+[Ansible](https://www.ansible.com/) to build an DISA STIG compliant Windows Server 2016 image on AWS.

This role is based on Windows Server 2016 DISA STIG: [Version 2, Rel 1 released on November 13, 2020](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_MS_Windows_Server_2016_V2R1_STIG.zip).

Requirements
------------
- Windows Server 2016 (Other versions are not supported.)
- AWS CLI - [install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- AWS IAM programmatically credentials
- Packer installed - [install Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- Ansible installed - [install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Packer variables file
----------------
All the adjustments/definitions are made on the `variables.pkr.hcl` file.


Dependencies
------------

The following packages must be installed on the controlling host/host where ansible is executed:

- passlib (or python2-passlib, if using python2)
- python-lxml
- python-xmltodict
- python-jmespath
- pywinrm

Package 'python-xmltodict' is required if you enable the OpenSCAP tool installation and run a report. Packages python(2)-passlib and python-jmespath are required for tasks with custom filters or modules. These are all required on the controller host that executes Ansible.

Role Variables
--------------

Please see the Ansible docs for understanding [variable precedence](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) to tailor for your needs. 

| Name                     | Default Value       | Description                   |
|--------------------------|-----------------------------------------------------|----------------------|
| `win2016stig_cat1_patch` | `yes`  see defaults/main.yml](./defaults/main.yml)  | Correct CAT I findings        |
| `win2016stig_cat2_patch` | `yes`  see defaults/main.yml](./defaults/main.yml)  | Correct CAT II findings       |
| `win2016stig_cat3_patch` | `yes`  see defaults/main.yml](./defaults/main.yml)  | Correct CAT III findings      |
| `wn16_##_######`         | [see defaults/main.yml](./defaults/main.yml)        | Individual variables to enable/disable each STIG ID. |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - role: win-2k16-stig
           when:
                - ansible_os_family == 'Windows'
                - ansible_distribution | regex_search('(Server 2016)')


Packer usage
----------------
1. With your IAM programmatically credentials, login to  AWS CLI running:
```shell
aws configure
```

2. Run the following command on the `packer` folder, to initialize the modules 
```shell
packer init .
```
3. Run the following command to validate all the infrastructure that Packer will deploy on AWS:
```shell
packer validate . 
```
 4. Run the following command to deploy the EC2 on AWS, to build the image:
```shell
packer build . 
```