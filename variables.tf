variable "team_name" {}

variable "application" {}

variable "environment-name" {}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  default     = "mojdigital"
}

variable "engine_type" {
  description = "Engine used e.g. postgres"
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version to use e.g. 9.6"
  default     = "9.6"
}

variable "instance_type" {
  description = "replication instance size, e.g dms.t2.medium"
  default     = "dms.t2.medium"
}

variable "aws_region" {
  description = "Region into which the resource will be created."
  default     = "eu-west-2"
}

variable "source_database_name" {
  description = "Name of source database (psql -d)"
}

variable "source_database_username" {
  description = "username in source database (psql -U)"
}

variable "source_database_password" {
  description = "user's password in source database"
}

variable "source_database_host" {
  description = "host, endpoint of source database (psql -h)"
}

variable "target_database_name" {
  description = "Name of target database (psql -d)"
}

variable "target_database_username" {
  description = "username in target database (psql -U)"
}

variable "target_database_password" {
  description = "user's password in target database (psql -d)"
}

variable "target_database_host" {
  description = "host, endpoint of target database (psql -d)"
}
