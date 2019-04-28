terraform {
  backend "s3" {
    bucket         = "${var.bucket}" # change it to the name of the name of your bucket
    key            = "${var.env}"
    region         = "${var.region}"
    dynamodb_table = "${var.dynamodb_table}"
  }
}
