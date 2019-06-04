terraform {
  backend "s3" {
    bucket         = "terraform-state-ganga-us-east-2" # change it to the name of the name of your bucket
    key            = "dev"
    region         = "us-east-2"
    profile        = "grayudu"
  }
}
