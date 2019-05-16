# AWS 3tier app demo


## Details

* demo application hosted on default VPC of aws and subnets.
* deveoped using terraforms, chef-solo
* AWS KMS used for pushing secrets to cloud.

## Step 1 - Creating S3 buckets and RDS and also KMS
```hcl
cd terraform/otc
terraform init
terraform plan
terraform apply #say yes when all resources listing correctly
```
## Step 2 DB config and secrets upload to s3 secret bucket
- update all attributes with otc terraform outputs details #config.py.
- update script with kms alias and bucket details #secrets_upload.sh
- encrypt file (get kms id from otc terraform outputs)
```
- execute ./secrets_upload.sh
```

## Step 3 Upload Chef cookbooks and image file to s3
```
- aws --profile <profile> s3 cp /Users/grayudu/Downloads/sf.jpeg s3://<s3bucket>/
- aws --profile <profile> s3api put-object-acl --bucket <s3bucket> --key sf.jpeg --acl public-read
```
upload chef
```
cd chef
- update attributes for s3 bucket details
zip -r chef-0.1.0.zip * #get all cookbooks, recipes, roles and environments.
aws --profile grayudu s3 cp chef-0.1.0.zip s3://<s3bucket>/
```
## Step 4 execute demo app
```hcl
cd terraform/demo
terraform init
terraform plan
terraform apply #say yes when all resources listing correctly
```
