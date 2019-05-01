terraform {
  backend "s3" {
    bucket         = "terraform-statelock-store-uswest" # change it to the name of the name of your bucket
    key            = "dev"
    region         = "us-west-2"
    profile        = "grayudu"
    dynamodb_table = "terraform-statelock-uswest"
  }
}

