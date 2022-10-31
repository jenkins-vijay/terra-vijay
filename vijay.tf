terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA3LDGB673OJZH7KI5"
  secret_key = "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"
}
