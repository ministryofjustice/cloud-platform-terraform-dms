# AWS DMS Terraform module

This terraform module will create a full DMS stack.

The AWS Database Migration Service is used to migrate data from a database (RDS or external) to an RDS instance in the Cloud platform VPC.

## Pre-requirements

 1 - The _source_ database needs to have its _Public Accessibility_ settings turned on (or the equivalent firewall rule in other environments)

 2 - For Postgres-to-Postgres, the _source_ RDS's parameter group need to comply with :
   - rds.logical_replication = 1
   - max_replication_slots > 5

 **DMS ONLY MIGRATES DATA, NO PRE-DATA, POST-DATA(CONSTRAINTS), USERS, ROLES, ETC.**

## Usage

This module follows the MOJ's standard practices for modules. Team, BU, application and environment are passed down to the module.

The module will not require connection information for the _source_ and the _target_ RDS, those will be defined via the API using the credentials in output.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dms_endpoint.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_endpoint.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_replication_instance.replication-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_instance) | resource |
| [aws_dms_replication_subnet_group.replication-subnet-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | resource |
| [aws_dms_replication_task.replication-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [local_file.replication-tasks-settings](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | n/a | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region into which the resource will be created. | `string` | `"eu-west-2"` | no |
| <a name="input_business-unit"></a> [business-unit](#input\_business-unit) | Area of the MOJ responsible for the service | `string` | `"mojdigital"` | no |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | Engine used e.g. postgres | `string` | `"postgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use e.g. 9.6 | `string` | `"9.6"` | no |
| <a name="input_environment-name"></a> [environment-name](#input\_environment-name) | n/a | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | replication instance size, e.g dms.t2.medium | `string` | `"dms.t2.medium"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_source_database_host"></a> [source\_database\_host](#input\_source\_database\_host) | host, endpoint of source database (psql -h) | `any` | n/a | yes |
| <a name="input_source_database_name"></a> [source\_database\_name](#input\_source\_database\_name) | Name of source database (psql -d) | `any` | n/a | yes |
| <a name="input_source_database_password"></a> [source\_database\_password](#input\_source\_database\_password) | user's password in source database | `any` | n/a | yes |
| <a name="input_source_database_username"></a> [source\_database\_username](#input\_source\_database\_username) | username in source database (psql -U) | `any` | n/a | yes |
| <a name="input_target_database_host"></a> [target\_database\_host](#input\_target\_database\_host) | host, endpoint of target database (psql -d) | `any` | n/a | yes |
| <a name="input_target_database_name"></a> [target\_database\_name](#input\_target\_database\_name) | Name of target database (psql -d) | `any` | n/a | yes |
| <a name="input_target_database_password"></a> [target\_database\_password](#input\_target\_database\_password) | user's password in target database (psql -d) | `any` | n/a | yes |
| <a name="input_target_database_username"></a> [target\_database\_username](#input\_target\_database\_username) | username in target database (psql -U) | `any` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
