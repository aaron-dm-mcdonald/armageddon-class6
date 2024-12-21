variable "backend_config" {
  description = "Configuration for the backend module"
  type = object({
    backend_instance_type = list(string)
    desired_capacity      = number
    scaling_range         = list(number)
    user_data             = string
  })

  default = {
    backend_instance_type = ["t2.micro", "t3.micro"]
    desired_capacity      = 2
    scaling_range         = [1, 3]
    user_data             = "./scripts/metadata.sh"
  }
}

variable "osaka_config" {
  description = "Configuration for the osaka environment"
  type = object({
    region                = string
    name                  = string
    vpc_cidr              = string
    public_subnet_cidr    = list(string)
    private_subnet_cidr   = list(string)
    database_subnet_cidr  = list(string)
    enable_public_subnets = bool
  })

  default = {
    region                = "ap-northeast-3"
    name                  = "osaka"
    vpc_cidr              = "10.159.0.0/16"
    public_subnet_cidr    = ["10.159.1.0/24"]
    private_subnet_cidr   = ["10.159.11.0/24", "10.159.12.0/24", "10.159.13.0/24"]
    database_subnet_cidr  = ["10.159.100.0/24", "10.159.101.0/24"]
    enable_public_subnets = false
  }
}

variable "tokyo_config" {
  description = "Configuration for the tokyo environment"
  type = object({
    region               = string
    name                 = string
    vpc_cidr             = string
    public_subnet_cidr   = list(string)
    private_subnet_cidr  = list(string)
    database_subnet_cidr = list(string)
  })

  default = {
    region               = "ap-northeast-1"
    name                 = "tokyo"
    vpc_cidr             = "10.160.0.0/16"
    public_subnet_cidr   = ["10.160.1.0/24", "10.160.2.0/24"]
    private_subnet_cidr  = ["10.160.11.0/24", "10.160.12.0/24", "10.160.13.0/24"]
    database_subnet_cidr = ["10.160.100.0/24", "10.160.101.0/24"]
  }
}

variable "new_york_config" {
  description = "Configuration for the new_york environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "us-east-1"
    name                = "new-york"
    vpc_cidr            = "10.161.0.0/16"
    public_subnet_cidr  = ["10.161.1.0/24", "10.161.2.0/24"]
    private_subnet_cidr = ["10.161.11.0/24", "10.161.21.0/24"]
  }
}

variable "london_config" {
  description = "Configuration for the london environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "eu-west-2"
    name                = "london"
    vpc_cidr            = "10.162.0.0/16"
    public_subnet_cidr  = ["10.162.1.0/24", "10.162.2.0/24"]
    private_subnet_cidr = ["10.162.11.0/24", "10.162.21.0/24"]

  }
}

variable "sao_paulo_config" {
  description = "Configuration for the sao_paulo environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "sa-east-1"
    name                = "sao-paulo"
    vpc_cidr            = "10.163.0.0/16"
    public_subnet_cidr  = ["10.163.1.0/24", "10.163.2.0/24"]
    private_subnet_cidr = ["10.163.11.0/24", "10.163.21.0/24"]
  }
}

variable "sydney_config" {
  description = "Configuration for the sydney environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-southeast-2"
    name                = "sydney"
    vpc_cidr            = "10.164.0.0/16"
    public_subnet_cidr  = ["10.164.1.0/24", "10.164.2.0/24"]
    private_subnet_cidr = ["10.164.11.0/24", "10.164.21.0/24"]
  }
}

variable "hong_kong_config" {
  description = "Configuration for the hong_kong environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "ap-east-1"
    name                = "hong-kong"
    vpc_cidr            = "10.165.0.0/16"
    public_subnet_cidr  = ["10.165.1.0/24", "10.165.2.0/24"]
    private_subnet_cidr = ["10.165.11.0/24", "10.165.21.0/24"]
  }
}

variable "norcal_config" {
  description = "Configuration for the norcal environment"
  type = object({
    region              = string
    name                = string
    vpc_cidr            = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
  })

  default = {
    region              = "us-west-1"
    name                = "norcal"
    vpc_cidr            = "10.166.0.0/16"
    public_subnet_cidr  = ["10.166.1.0/24", "10.166.2.0/24"]
    private_subnet_cidr = ["10.166.11.0/24", "10.166.21.0/24"]
  }
}