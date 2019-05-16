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
## Step 2 DB config ready
- update all attributes with otc terraform outputs details.
- encrypt file (get kms id from otc terraform outputs)
```
  - aws --profile <profile> kms encrypt --key-id <kms-id> --plaintext fileb://config.py --query CiphertextBlob --output text | base64 --decode > ~/Downloads/dbconfig.enc
  - aws --profile <profile> s3api put-object --bucket <secret-bucket> --key dbconfig --acl private --body ~/Downloads/dbconfig.enc  --output text --query 'None' | egrep -v '^None$' || true
```
## Step 3 Upload all secrets to secret bucket
- update script with kms alias and bucket details
```
- execute ./secrets_upload.sh
```

## Step 4 Upload Chef cookbooks and image file to s3
```
- aws --profile <profile> s3 cp /Users/grayudu/Downloads/sf.jpeg s3://<s3bucket>/
- aws --profile <profile> s3api put-object-acl --bucket <s3bucket> --key sf.jpeg --acl public-read

```






