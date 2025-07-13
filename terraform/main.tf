terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.3.0"
    }
  }
  
  backend "s3" {
    bucket = "harish8010-terraform-state"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
}

}

provider "aws" {
  region                    = "ap-south-1"
  profile                   = "dev"
  shared_config_files       = ["creds/aws/config"]
  shared_credentials_files  = ["creds/aws/credentials"]
}

