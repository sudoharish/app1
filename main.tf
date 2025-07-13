terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.3.0"
    }
  }
}

provider "aws" {
  region                    = "ap-south-1"
  profile                   = "dev"
  shared_config_files       = ["creds/aws/config"]
  shared_credentials_files  = ["creds/aws/credentials"]
}
