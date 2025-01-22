variable "vpc_id" {
  type = string
}

variable "region" {
  description = "The region in which to create the network"
  type        = string
}

variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "db_subnet_group" {
  type = string
}

variable "instance_count" {
  type = number

}

variable "instance_class" {
  type = string

}

variable "db_user" {
  type = string
  default = "admin"
}    
 
variable "db_password" {
  type = string
  default = "password"

}