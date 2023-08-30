locals {
  default_tags = {
    # Mandatory
    business-unit = var.business_unit
    application   = var.application
    is-production = var.is_production
    Owner         = var.team_name # this is capitalised due to the IAM policy used on line 79
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name == "live" ? "live-1" : var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    SubnetType = "Private"
  }
}

resource "random_id" "id" {
  byte_length = 8
}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "replication-subnet-group" {
  replication_subnet_group_description = "Replication subnet group for ${var.application}"
  replication_subnet_group_id          = "${var.team_name}-sg-${random_id.id.hex}"
  subnet_ids                           = data.aws_subnets.private.ids

  tags = merge(local.default_tags, {
    Name        = "${var.team_name} DMS subnet group"
    Description = "Managed by Terraform"
  })
}

# Create a new replication instance
resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage           = var.allocated_storage
  apply_immediately           = true
  auto_minor_version_upgrade  = false
  engine_version              = "3.4.7"
  publicly_accessible         = false
  replication_instance_class  = var.instance_type
  replication_instance_id     = "${var.team_name}-dms-${random_id.id.hex}"
  replication_subnet_group_id = aws_dms_replication_subnet_group.replication-subnet-group.id

  tags = merge(local.default_tags, {
    Name        = "${var.team_name} Replication Instance"
    Description = "Managed by Terraform"
  })
}

# Legacy long-lived credentials
resource "aws_iam_user" "dms_user" {
  name = "dms-${var.team_name}-${random_id.id.hex}"
  path = "/system/dms-user/"

  tags = local.default_tags
}

resource "aws_iam_access_key" "dms_key" {
  user = aws_iam_user.dms_user.name
}

# as per https://docs.aws.amazon.com/service-authorization/latest/reference/list_awsdatabasemigrationservice.html
# the only way to filter DMS actions is by checking resource tags (users can edit only resources that have the tag 'Owner' set to their team)

data "aws_iam_policy_document" "dms_policy" {
  statement {
    actions = [
      "dms:*",
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Owner"
      values   = [var.team_name]
    }
  }
  statement {
    actions = [
      "dms:DescribeReplicationInstances",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "dms:DescribeReplicationTasks",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "dms-${var.team_name}-${random_id.id.hex}"
  policy = data.aws_iam_policy_document.dms_policy.json
  user   = aws_iam_user.dms_user.name
}

# Short-lived credentials (IRSA)
data "aws_iam_policy_document" "irsa" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "AllowOwnDMSFor${random_id.id.hex}"
    actions = [
      "dms:*",
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Owner"
      values   = [var.team_name]
    }
  }
  statement {
    effect = "Allow"
    sid    = "AllowDescribeFor${random_id.id.hex}"
    actions = [
      "dms:DescribeReplicationInstances",
      "dms:DescribeReplicationTasks",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "irsa" {
  name   = "cloud-platform-dms-${random_id.id.hex}"
  path   = "/cloud-platform/dms/"
  policy = data.aws_iam_policy_document.irsa.json
  tags   = local.default_tags
}
