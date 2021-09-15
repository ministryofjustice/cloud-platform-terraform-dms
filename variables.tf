variable "cluster_name" {
}

variable "team_name" {
}

variable "application" {
}

variable "environment-name" {
}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  default     = "mojdigital"
}

variable "is-production" {
  default = "false"
}

variable "namespace" {
}

variable "instance_type" {
  description = "replication instance size, e.g dms.t2.medium"
  default     = "dms.t2.medium"
}

variable "allocated_storage" {
  description = "how many GB for local buffer"
  default     = 32
}

variable "aws_region" {
  description = "Region into which the resource will be created."
  default     = "eu-west-2"
}
