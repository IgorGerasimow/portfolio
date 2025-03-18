resource "aws_s3_bucket" "terraform_states" {
  bucket = "${var.project_name}-${var.subproject_name}-${local.short_region}-tfstate-${var.env}"
  acl    = "private"

  tags = {
    svc         = "terraform"
    env         = var.env
    team        = var.subproject_name
    group       = "terraform"
    region      = var.region
  }
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.project_name}-${var.subproject_name}-${local.short_region}-tfstate-${var.env}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    svc         = "terraform"
    env         = var.env
    team        = var.subproject_name
    group       = "terraform"
    region      = var.region
  }
}