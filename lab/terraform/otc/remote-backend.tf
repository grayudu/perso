terraform {
  backend "s3" {
    bucket         = "terraform-state-ganga-_region_" # change it to the name of the name of your bucket
    key            = "otc-_region_"
    region         = "_region_"
    profile        = "grayudu"
  }
}
