# terragrunt-brown-bag
Terragrunt and Terraform SEP Brown bag


## Steps to run:
* `az login`
    - You will need an Azure account 
    -  With the current setup, you'll still need to updated the subscription_id in the  `subscription.hcl` files
* Cd into the inner app you want to run
* `terragrunt apply`

* `terragrunt destroy`