data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.cluster_name == "live" ? "live-1" : var.cluster_name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

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
  subnet_ids                           = data.aws_subnet_ids.private.ids

  tags = {
    Name        = "${var.team_name} DMS subnet group"
    Description = "Managed by Terraform"
    Env         = var.environment-name
    Owner       = var.team_name
    namespace   = var.namespace
  }
}

# Create a new replication instance
resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage           = var.allocated_storage
  apply_immediately           = true
  auto_minor_version_upgrade  = false
  engine_version              = "3.4.5"
  publicly_accessible         = false
  replication_instance_class  = "dms.t2.medium"
  replication_instance_id     = "${var.team_name}-dms-${random_id.id.hex}"
  replication_subnet_group_id = aws_dms_replication_subnet_group.replication-subnet-group.id

  tags = {
    Name                   = "${var.team_name} Replication Instance"
    Description            = "Managed by Terraform"
    Application            = var.application
    Owner                  = var.team_name
    is-production          = var.is-production
    environment-name       = var.environment-name
    infrastructure-support = var.infrastructure-support
  }
}

resource "aws_iam_user" "dms_user" {
  name = "dms-${var.team_name}-${random_id.id.hex}"
  path = "/system/dms-user/"
}

resource "aws_iam_access_key" "dms_key" {
  user = aws_iam_user.dms_user.name
}

data "aws_iam_policy_document" "dms_policy" {
  statement {
    actions = [
      "dms:*",
    ]
    resources = [
      "*",
    ]
    condition {
      test = "StringEquals"
      variable = "aws:ResourceTag/Owner"
      values = [
        "${var.team_name}"
      ]
    }
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "dms-${var.team_name}-${random_id.id.hex}"
  policy = data.aws_iam_policy_document.dms_policy.json
  user   = aws_iam_user.dms_user.name
}
