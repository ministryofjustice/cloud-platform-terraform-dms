#################
# Configuration #
#################
variable "vpc_name" {
  description = "VPC name to create security groups in for the ElastiCache and RDS modules"
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

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}

variable "engine_version" {
  description = "The version of the engine to use"
  default     = "3.5.3"
  type        = string
}