data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
  }
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

# ------------------------------------------------------------------------------
# CHD BEP Data
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "chd_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

# Disabled for now - will be used once backends have been identified and defined
#data "vault_generic_secret" "chd_bep_data" {
#  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/backend"
#}

data "aws_ami" "chd_bep" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.bep_ami_name == "chd-backend-*" ? true : false

  filter {
    name = "name"
    values = [
      var.bep_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "bep_userdata" {
  template = file("${path.module}/templates/bep_user_data.tpl")

  vars = {
    REGION             = var.aws_region
#    CHD_BACKEND_INPUTS = local.chd_bep_data
    CHD_BACKEND_INPUTS = ""
    ANSIBLE_INPUTS     = jsonencode(local.chd_bep_ansible_inputs)
    CHD_CRON_ENTRIES   = templatefile("${path.module}/templates/bep_cron.tpl", { "USER" = "", "PASSWORD" = "" })
  }
}

data "template_cloudinit_config" "bep_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.bep_userdata.rendered
  }
}
