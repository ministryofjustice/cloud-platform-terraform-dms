# AWS DMS Terraform module

This terraform module will create a full DMS stack.

The AWS Database Migration Service is used to migrate data from a database (RDS or external) to an RDS instance in the Cloud platform VPC.

## Pre-requirements

 1 - The _source_ database needs to have its _Public Accessibility_ settings turned on (or the equivalent firewall rule in other environments)
 2 - For Postgrs-to-Postgres, the _source_ RDS's parameter group need to comply with :
   - rds.logical_replication = 1
   - max_replication_slots > 5

 **DMS ONLY MIGRATES DATA, NO PRE-DATA, POST-DATA(CONSTRAINTS), USERS, ROLES, ETC.**

## Usage

This module follows the MOJ's standard practices for modules. Team, BU, application and environment are passed down to the module.
On top of those, this module requires connection information to access the _source_ and the _target_ RDS.


<!-- BEGIN_TF_DOCS -->
```hcl
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

```
<!-- END_TF_DOCS -->
