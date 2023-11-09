terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.23.0"      
    }
  }
}
provider "aws" {
  alias = "us-east"
  region = "us-east-1"
}