provider "aws" {
  version = "2.54"
  region  = var.region
}


terraform {
  backend "s3" {
    region = var.region
  }
}
