terraform {
  cloud {
    organization = "tomondre"

    workspaces {
      tags = ["blog"]
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  name_prefix = "blog"
}