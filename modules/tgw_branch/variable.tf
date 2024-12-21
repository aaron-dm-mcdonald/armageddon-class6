variable "region" {
  description = "region where the transit gateway will be created"
  type        = string
}

variable "name" {
  description = "name of the transit gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with the transit gateway"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnet IDs to associate with the transit gateway"
  type        = list(string)
}

variable "peer_tgw_id" {
  description = "Peer Transit Gateway ID"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_return_route" {
  description = "Enable or Disable return routes (HQ/Tokyo *to* this region)"
  type        = bool
  default     = false
}