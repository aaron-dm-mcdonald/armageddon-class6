terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

 /*  backend "s3" {
    bucket  = "tf-backend-4357232"           # Name of the S3 bucket
    key     = "armageddon-modules-3.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                    # Use a variable for the region
    encrypt = true                           # Enable server-side encryption (optional but recommended)
  } */

  cloud { 
    
    organization = "test-4" 

    workspaces { 
      name = "armageddon-actions" 
    } 
  } 
}

provider "aws" {
  alias  = "tokyo"
  region = var.tokyo_config.region
}

provider "aws" {
  alias  = "osaka"
  region = var.osaka_config.region
}

provider "aws" {
  alias  = "new_york"
  region = var.new_york_config.region
}

provider "aws" {
  alias  = "london"
  region = var.london_config.region
}

provider "aws" {
  alias  = "sao_paulo"
  region = var.sao_paulo_config.region
}

provider "aws" {
  alias  = "sydney"
  region = var.sydney_config.region
}

provider "aws" {
  alias  = "hong_kong"
  region = var.hong_kong_config.region
}

provider "aws" {
  alias  = "norcal"
  region = var.norcal_config.region
}
