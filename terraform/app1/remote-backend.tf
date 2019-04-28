terraform {
  backend "s3" {
    bucket         = "terraform-statelock-store-useast" # change it to the name of the name of your bucket
    key            = "dev"
    region         = "us-east-1"
    profile        = "grayudu"
    dynamodb_table = "terraform-statelock-useast"
  }
}
