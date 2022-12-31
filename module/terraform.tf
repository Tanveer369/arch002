terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-excercise2-bucket"
    region         = "us-east-2"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-dynamo-db-lock-state-file"
  }
}