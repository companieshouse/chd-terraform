# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs = values(data.vault_generic_secret.internal_cidrs.data)

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  default_tags = {
    Terraform = "true"
    Region    = var.aws_region
    Account   = var.aws_account
  }

# ------------------------------------------------------------------------------
# CHD Common
# ------------------------------------------------------------------------------
  chd_ec2_data = data.vault_generic_secret.chd_ec2_data.data
  s3_releases  = data.vault_generic_secret.s3_releases.data

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

# ------------------------------------------------------------------------------
# CHD Frontend
# ------------------------------------------------------------------------------
  chd_fe_data = data.vault_generic_secret.chd_fe_data.data_json

  fe_cw_logs = { for log, map in var.fe_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-fe-${log}" }) }
  fe_log_groups = compact([for log, map in local.fe_cw_logs : lookup(map, "log_group_name", "")])

  fe_alb_app_access = length(var.fe_access_cidrs) != 0 ? [
    {
      rule        = "http-80-tcp"
      description = "Application Access"
      cidr_blocks = join(",", var.fe_access_cidrs)
    },
    {
      rule        = "https-443-tcp"
      description = "Application Access"
      cidr_blocks = join(",", var.fe_access_cidrs)
    }
  ] : []

  # Define the NLB FTP target group ARNs (index 2) for ASG registration
  chd_fe_internal_ftp_target_group_arn = [module.nlb_fe_internal.target_group_arns[2]]
  chd_fe_external_ftp_target_group_arn = [module.nlb_fe_external.target_group_arns[2]]

  # Generate listener configuration for FTP passive ports
  chd_fe_ftp_passive_listeners = [
    for num in range(var.fe_ftp_passive_ports_start, var.fe_ftp_passive_ports_end) : {
      port               = format("%d", num)
      protocol           = "TCP"
    }
  ]

  # Generate target group configuration for FTP passive ports
  # Internal NLB TGs
  chd_fe_internal_ftp_passive_tgs = [
    for num in range(var.fe_ftp_passive_ports_start, var.fe_ftp_passive_ports_end) : {
      name                 = "tg-${var.application}-fe-int-ftp-${num}"
      backend_protocol     = "TCP"
      backend_port         = num
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        port                = 21
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "TCP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    }
  ]

  # External NLB TGs
  chd_fe_external_ftp_passive_tgs = [
    for num in range(var.fe_ftp_passive_ports_start, var.fe_ftp_passive_ports_end) : {
      name                 = "tg-${var.application}-fe-ext-ftp-${num}"
      backend_protocol     = "TCP"
      backend_port         = num
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        port                = 21
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "TCP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    }
  ]

  chd_fe_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.fe_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.fe_cw_logs
    cw_agent_user              = "root"
  }

# ------------------------------------------------------------------------------
# CHD BEP
# ------------------------------------------------------------------------------
  chd_bep_data = data.vault_generic_secret.chd_bep_data.data_json

  bep_cw_logs = { for log, map in var.bep_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-bep-${log}" }) }
  bep_log_groups = compact([for log, map in local.bep_cw_logs : lookup(map, "log_group_name", "")])

  chd_bep_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.bep_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.bep_cw_logs
    cw_agent_user              = "root"
  }

}
