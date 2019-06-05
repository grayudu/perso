terraform {
  backend "s3" {
    bucket         = "terraform-state-ganga-us-east-2" # change it to the name of the name of your bucket
    key            = "otc-_region_"
    region         = "_region_"
    profile        = "grayudu"
  }
}
