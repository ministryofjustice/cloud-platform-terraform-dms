variable "vpc_name" {
  description = "VPC name to create security groups in for the ElastiCache and RDS modules"
  type        = string
}

variable "team_name" {
  description = "Name of the development team responsible for this service"
  type        = string
}

variable "application" {
  description = "Name of the application you are deploying"
  type        = string
}

variable "environment-name" {
  description = "Name of the environment type for this service"
  type        = string
}

variable "business-unit" {
  description = "Area of the MOJ responsible for this service"
  type        = string
}

variable "is-production" {
  description = "Whether this environment type is production or not"
  type        = string
}

variable "infrastructure-support" {
  description = "Email address of the team responsible this service"
  type        = string
}

variable "namespace" {
  description = "Name of the namespace these resources are part of"
  type        = string
}

variable "instance_type" {
  description = "replication instance size, e.g dms.t2.medium"
  default     = "dms.t2.medium"
  type        = string
}

variable "allocated_storage" {
  description = "how many GB for local buffer"
  default     = 32
  type        = number
}
