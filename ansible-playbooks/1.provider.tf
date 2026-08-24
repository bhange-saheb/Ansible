provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "<= 1.14.9" #Forcing which version of Terraform needs to be used
  required_providers {
    aws = {
      version = "<= 6.60.0" #Forcing which version of plugin needs to be used.
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "ankit-ansible"
    key    = "ansible.tfstate"
    region = "us-east-1"
    # dynamodb_table = "-terraform-locks"
    encrypt = true
  }
}
