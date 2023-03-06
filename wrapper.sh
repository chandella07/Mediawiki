#!/bin/bash

# Prompt user for username of VM
read -s -p "Enter VM Username: "$'\n' ADMIN_USERNAME

# Prompt user for password of VM User
read -s -p "Enter VM user's password: "$'\n' ADMIN_PASSWORD

# Prompt user for mysql root password
read -s -p "Enter mysql root password: "$'\n' MYSQL_ROOT_PASSWORD

# Prompt user for mysql user password
read -s -p "Enter mysql user password: "$'\n' MYSQL_USER_PASSWORD

# Setting ENV Vars
export TF_VAR_admin_user=$ADMIN_USERNAME
export TF_VAR_admin_passwd=$ADMIN_PASSWORD
export mysql_root_pwrd=$MYSQL_ROOT_PASSWORD
export mysql_user_pwrd=$MYSQL_USER_PASSWORD

# moving to terraform dir
cd mediawiki-terraform


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

