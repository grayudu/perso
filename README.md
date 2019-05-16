# AWS 3tier app demo


## Details

* demo application hosted on default VPC of aws and subnets.
* deveoped using terraforms, chef-solo
* AWS KMS used for pushing secrets to cloud.

- Step 1
```hcl
cd terraform/otc
terraform init
terraform plan
terraform apply #say yes when all resources listing correctly
```

