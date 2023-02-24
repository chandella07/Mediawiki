Deploying and Configuring MediaWiki Application with Terraform and Ansible
==========================================================================

This project provides Terraform code and an Ansible role to deploy and configure the MediaWiki application on a Azure VM. The Terraform code provisions the necessary infrastructure resources, such as the virtual machines, VNET, Subnets, public ip and NSG's, while the Ansible role configures the MediaWiki application on the provisioned infrastructure.

Prerequisites
-------------

Before deploying the MediaWiki application, make sure you have the following tools installed on execution machine:

- Terraform
- Ansible

Variables
---------

Before execution please set below variables in your environment.

    export TF_VAR_admin_user="azureuser"
    export TF_VAR_admin_passwd="********"
    export mysql_root_pwrd="********"
    export mysql_user_pwrd="********"

also update terraform.tfvars file with below variables:

    vm_size = "size_code_of_vm"
    rg_name = "azure_resource_group_name"
    rg_location = "azure_resource_group_location"

**NOTE** Environment variables have been used for providing layer of abstraction.

Deployment Steps
----------------

Clone the repository to your local machine amd navigate to the terraform directory first.

execute below commands:


    # initialize the provider
    - terraform init    

    # make a plan
    - terraform plan -out plan.out

    # apply the created plan
    - terraform apply plan.out


Once the infrastructure is provisioned, now it's time to configure our application on VM.
before that set `VM_IP` as another env variable to be accessed from anywhere in the execution env easily.

    export VM_IP="public_ip_of_vm"

Now, go to ansible role directory and execute the `test-playbook.yml` files with below parameters.


    ansible-playbook -i $VM_IP, test-playbook.yml -e "ansible_user=$TF_VAR_admin_user" -e "ansible_password=$TF_VAR_admin_passwd" -e "ansible_sudo_pass=$TF_VAR_admin_passwd"


Once the playbook completes, the MediaWiki application should be accessible at the VM IP address. Open a web browser and navigate to the VM IP address to confirm that the application is running.

Configuration
-------------

The `mediawiki-ansible` role installs the MediaWiki application and its dependencies, and configures the application with the necessary settings. You can modify the playbooks in this role to customize the configuration of the MediaWiki application.

playbooks can be found under `tasks` directory of the role.

    ─ tasks
        ├── main.yml
        ├── install_packages.yml
        ├── mariadb.yml
        ├── mediawiki.yml
        ├── firewall.yml
        ├── selinux.yml
        ├── generate_ssl_cert.yml
        └── restart.yml
        

Clean Up
--------

To clean up the provisioned infrastructure resources, navigate to the terraform directory and run terraform destroy.

    - terraform apply -destroy


Other Content
-------------

**wrapper.sh**


For seamless execution, below shell script can be utilized:
**NOTE** This is not fully tested

    #!/bin/bash

    # Prompt user for username of VM
    read -s -p "Enter VM Username: " ADMIN_USERNAME
    # Prompt user for password of VM User
    read -s -p "Enter VM user's password: " ADMIN_PASSWORD
    # Prompt user for mysql root password
    read -s -p "Enter mysql root password: " MYSQL_ROOT_PASSWORD
    # Prompt user for mysql user password
    read -s -p "Enter mysql user password: " MYSQL_USER_PASSWORD

    # Setting ENV Vars
    export TF_VAR_admin_user=$ADMIN_USERNAME
    export TF_VAR_admin_passwd=$ADMIN_PASSWORD
    export mysql_root_pwrd=$MYSQL_ROOT_PASSWORD
    export mysql_user_pwrd=$MYSQL_USER_PASSWORD

    # moving to terraform dir
    cd mediawiki/mediawiki-terraform

    # Executing terraform for creating infrastructure
    terraform init
    terraform plan -out plan.out
    terraform apply plan.out -auto-approve

    # Setting VM_IP to env
    export VM_IP=$(terraform output azurerm_linux_virtual_machine.tf_vm1.public_ip_address)

    # moving to ansible dir
    cd ../mediawiki-ansible/

    # executing ansible role
    ansible-playbook -i $VM_IP, test-playbook.yml -e "ansible_user=$TF_VAR_admin_user" -e "ansible_password=$TF_VAR_admin_passwd" -e "ansible_sudo_pass=$TF_VAR_admin_passwd"


**Tags**

ansible tags can be utilized to configure any specific tasks


