provider "aws" {
  version = "2.49"
  region = var.region
}

terraform {
  backend "s3" {
    region         = var.region
    # acl            = "bucket-owner-full-control"
  }
}