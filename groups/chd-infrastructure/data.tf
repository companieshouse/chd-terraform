data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-public-*"]
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-web-*"]
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
  }
}

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

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_acm_certificate" "acm_cert" {
  domain      = var.fe_domain_name
  most_recent = true
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "test_cidrs" {
  path = "aws-accounts/network/shared-services/test_cidr_ranges"
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

data "aws_ami" "chd_bep_ami" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.bep_ami_name == "chd-*" ? true : false

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

data "aws_ami" "chd_fe_ami" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.fe_ami_name == "chd-*" ? true : false

  filter {
    name = "name"
    values = [
      var.fe_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

# ------------------------------------------------------------------------------
# CHD Frontend Data
# ------------------------------------------------------------------------------
data "aws_security_group" "identity_gateway" {
  name  = "identity-gateway-instance"
}

data "vault_generic_secret" "chd_fe_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/frontend"
}

data "template_file" "fe_userdata" {
  template = file("${path.module}/templates/fe_user_data.tpl")

  vars = {
    REGION                    = var.aws_region
    HERITAGE_ENVIRONMENT      = title(var.environment)
    APP_VERSION               = var.fe_app_release_version
    CHD_FRONTEND_INPUTS_PATH  = "${local.parameter_store_path_prefix}/frontend_inputs"
    ANSIBLE_INPUTS_PATH       = "${local.parameter_store_path_prefix}/frontend_ansible_inputs"
    ONLINE_MOUNT_PATH         = var.fe_online_mount_path
  }
}

data "template_cloudinit_config" "fe_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/fe_ftp_server.tpl", {
      int_passive_ports_start = var.fe_ftp_int_passive_ports_start
      int_passive_ports_end   = var.fe_ftp_int_passive_ports_end
      internal_nlb_name       = module.nlb_fe_internal.this_lb_dns_name
      ext_passive_ports_start = var.fe_ftp_ext_passive_ports_start
      ext_passive_ports_end   = var.fe_ftp_ext_passive_ports_end
      external_nlb_name       = module.nlb_fe_external.this_lb_dns_name
      root_dir                = var.fe_ftp_root_dir
    })
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.fe_userdata.rendered
  }
}

# ------------------------------------------------------------------------------
# CHD BEP Data
# ------------------------------------------------------------------------------
data "vault_generic_secret" "chd_bep_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/backend"
}

data "template_file" "chd_cron_file" {
  template = file("${path.module}/templates/${var.aws_profile}/chd_cron.tpl")
}

data "template_file" "bulkdata_cron_file" {
  template = file("${path.module}/templates/${var.aws_profile}/bulkdata_cron.tpl")
}

data "template_file" "bep_userdata" {
  template = file("${path.module}/templates/bep_user_data.tpl")

  vars = {
    REGION                     = var.aws_region
    HERITAGE_ENVIRONMENT       = title(var.environment)
    APP_VERSION                = var.bep_app_release_version
    CHD_BACKEND_INPUTS_PATH    = "${local.parameter_store_path_prefix}/backend_inputs"
    ANSIBLE_INPUTS_PATH        = "${local.parameter_store_path_prefix}/backend_ansible_inputs"
    CHD_CRON_ENTRIES_PATH      = "${local.parameter_store_path_prefix}/chd_cron_entries"
    BULKDATA_CRON_ENTRIES_PATH = "${local.parameter_store_path_prefix}/bulkdata_cron_entries"
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
