terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
}

locals {
  configurations = jsondecode(file("${path.module}/configurations-${terraform.workspace}.json"))
}