variable "region" {
  description = "The region in which to create the network"
  type        = string
}

variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_id" {
  description = "The id for the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs for the public subnets"
  type        = string
  default     = ""
}

variable "user_data" {
  type = string
}

