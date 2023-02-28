# terragrunt-brown-bag
Terragrunt and Terraform SEP Brown bag


## Steps to run Terragrunt package (inside GoodTf):
* Download necessary packages:
    - [Install terragrunt] (https://terragrunt.gruntwork.io/docs/getting-started/install/)
    - [Install Azure CLI] (https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) 


* `az login`
    - You will need an Azure account 
    -  With the current setup, you'll still need to updated the subscription_id in the  `subscription.hcl` files
* Cd into the inner `app` folder that you want to run (for example: GoodTf/terragrunt/subscriptions/nonprod/stg/eastus2/app)
    - We have a dependency where stg must be run first.
* `terragrunt apply`

* `terragrunt destroy`