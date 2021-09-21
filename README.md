# AWS DMS Terraform module

This terraform module will create a full DMS stack.

The AWS Database Migration Service is used to migrate data from a database (RDS or external) to an RDS instance in the Cloud platform VPC.

## Pre-requirements

 1 - The _source_ database needs to have its _Public Accessibility_ settings turned on (or the equivalent firewall rule in other environments)

 2 - For Postgres in RDS, the _source's_ parameter group need to comply with :
   - rds.logical_replication = 1
   - max_replication_slots > 5

 **DMS ONLY MIGRATES DATA, NO PRE-DATA, POST-DATA(CONSTRAINTS), USERS, ROLES, ETC.**

 **Continuous replication, especially between different engines, is a tricky business, see https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html for details**

## Schema migration

For a fresh, empty, destination database you will probably be fine with just leaving the `replication_task_settings` setting empty; as noted above though this will only get the data across, with no meta-information like transaction log, user accounts, foreign key constraints, etc.

 **For schema migration, try https://aws.amazon.com/dms/schema-conversion-tool/**

## Usage

This module follows the MOJ's standard practices for modules. Team, BU, application and environment are passed down to the module.

The module will not require connection information for the _source_ and the _target_ RDS, those will be defined in the environments repo using a secret that the team must first set in the namespace (see the `dms-secret.yaml` in the example dir for its structure).

Replication task settings are defined in a (lengthy) json file that will be loaded via the DMS API, not via terraform. Two examples of such are in the example/ dir, one for postgres-to-postgres the other for mssql-to-postgres.

Also via API using the output credentials the replication status can be queried and the task paused/resumed.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.58.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dms_replication_instance.replication-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_instance) | resource |
| [aws_dms_replication_subnet_group.replication-subnet-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | resource |
| [aws_iam_access_key.dms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.dms_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.dms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet_ids.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | how many GB for local buffer | `number` | `32` | no |
| <a name="input_application"></a> [application](#input\_application) | n/a | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region into which the resource will be created. | `string` | `"eu-west-2"` | no |
| <a name="input_business-unit"></a> [business-unit](#input\_business-unit) | Area of the MOJ responsible for the service | `string` | `"mojdigital"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_environment-name"></a> [environment-name](#input\_environment-name) | n/a | `any` | n/a | yes |
| <a name="input_infrastructure-support"></a> [infrastructure-support](#input\_infrastructure-support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | replication instance size, e.g dms.t2.medium | `string` | `"dms.t2.medium"` | no |
| <a name="input_is-production"></a> [is-production](#input\_is-production) | n/a | `string` | `"false"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | Access key id for the credentials |
| <a name="output_replication_instance_arn"></a> [replication\_instance\_arn](#output\_replication\_instance\_arn) | n/a |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | Secret for the new credentials |
<!-- END_TF_DOCS -->
