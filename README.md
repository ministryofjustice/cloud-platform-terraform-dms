# AWS DMS Terraform module

This terraform module will create a full DMS stack.

In the context of that module, the AWS Database Migration Service is used to migrate pure data from one RDS to another.

**THIS MODULE IS MEANT FOR THE CLOUD-PLATFORM TEAM TO USE**

**DO NOT COMMIT ANYTHING TO THE ENVIRONMNENT CODEBASE**

The plan is for this module to be use locally, against a local state, outside of any pipeline.
The reasons for this are : 
 - This is a one-off/temporary infrastructure component, that needs to be deleted once it has fulfilled its duty.
 - This module requires database credentials to be passed to it.
 

## Pre-requirements

 1 - The _source_ RDS needs to have its _Public Accessibility_ settings turned on.  
 2 - The _source_ RDS's parameter group need to comply with :
   - rds.logical_replication = 1
   - max_replication_slots > 5

 **DMS ONLY MIGRATES DATA, NO PRE-DATA, POST-DATA(CONSTRAINTS), USERS, ROLES, ETC.**

## Usage

This module follows the MOJ's standard practices for modules. Team, BU, application and environment are passed down to the module.
On top of those, this module requires connection information to access the _source_ and the _target_ RDS.



```hcl
module "example_dms" {
  source                   = "https://github.com/ministryofjustice/cloud-platform-terraform-dms?ref=1.0"
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

**MOST OF THOSE VARIABLES NEED TO DEFINED, PLEASE SEE THE EXAMPLE/DMS.TF FOR MORE DETAILS**

The _terraform.tfvars_ needs to be updated with the real values.

```
# Fill in with your own values
# Obviously don't commit any of that.

source_database_name = "example_db_name"
source_database_username = "example_db_username"
source_database_password = "example_db_password"
source_database_host = "example_rds_endpoint"
```