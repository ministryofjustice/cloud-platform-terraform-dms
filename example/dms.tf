variable "source_database_name" {}

variable source_database_username {}
variable source_database_password {}
variable source_database_host {}
variable target_database_name {}
variable target_database_username {}
variable target_database_password {}
variable target_database_host {}

module "example_dms" {
  source                   = "github.com/ministryofjustice/cloud-platform-terraform-dms?ref=1.1"
  team_name                = "example-team"
  business-unit            = "example-bu"
  application              = "exampleapp"
  environment-name         = "development"
  source_database_name     = "${var.source_database_name}"
  source_database_username = "${var.source_database_username}"
  source_database_password = "${var.source_database_password}"
  source_database_host     = "${var.source_database_host}"
  target_database_name     = "${var.target_database_name}"
  target_database_username = "${var.target_database_username}"
  target_database_password = "${var.target_database_password}"
  target_database_host     = "${var.target_database_host}"
}
