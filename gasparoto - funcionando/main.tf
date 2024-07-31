terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "example" {
  bucket = "cg123kolling12"

  tags = {
    Name        = "My-bucket"
    Environment = "Dev"
    created_at  = "2022-01-01"
    created_by  = "terraform"
    project     = "curso-gasparoto"
  }
}