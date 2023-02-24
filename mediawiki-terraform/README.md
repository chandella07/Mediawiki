Mediawiki-terraform
===================

This is the terraform directory containing multiple terraform files to achieve the common goal of deploying a IaaS VM on Azure cloud.

Requirements
------------

provider:
`Azurerm version >= 2.0`

Variables
---------

variables are defined in `variables.tf`
NOTE: For some variables values are fetched from environment vars.

Example
-------

Below is one sample cli

    # initialize the provider first
    - terraform init    

    # make a plan
    - terraform plan -out plan.out

    # apply the created plan
    - terraform apply plan.out

    # destroy the resources
    - terraform apply -destroy

NOTE: use `-auto-approve` option for seamless automation.

Directory strcuture
-------------------

    ├── mediawiki-terraform
    │   ├── README.md
    │   ├── beckend.tf_backup
    │   ├── main.tf
    │   ├── mytfplan.out
    │   ├── output.tf
    │   ├── plan.out
    │   ├── provider.tf
    │   ├── terraform.tfstate
    │   ├── terraform.tfstate.backup
    │   ├── terraform.tfvars
    │   └── variables.tf