# terraform {
#   backend "s3" {
#     bucket = "terraform_s3_test-project"
#     key    = "global/s3/terraform.tfstate"
#     region = "ap-south-1"
#     dynamodb_table = "terraform-state-locking"
#     encrypt = true
#   }
# }
# resource "aws_s3_bucket" "create_bucket" {
#   bucket = "terraform_s3_${local.project_name}"
#   acl = "private" 
#   lifecycle {
#     prevent_destroy = true
#   }
#   versioning {
#     enabled = true
#   }
#  }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name = "terraform-state-locking"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }