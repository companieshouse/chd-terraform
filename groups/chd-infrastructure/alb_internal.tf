# ------------------------------------------------------------------------------
# Internal ALB Security Group
# ------------------------------------------------------------------------------
module "chd_internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} web servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = concat(
    local.admin_cidrs,
    formatlist("%s/32", [for eni in data.aws_network_interface.nlb_fe_internal : eni.private_ip]),
    local.test_cidrs
  )

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ingress_with_cidr_blocks = local.fe_alb_app_access

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = data.aws_security_group.identity_gateway.id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = data.aws_security_group.identity_gateway.id
    }
  ]

  egress_rules = ["all-all"]
}

#--------------------------------------------
# Internal ALB Resource
#--------------------------------------------
module "chd_internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.16.0"

  name                       = "alb-${var.application}-internal-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.chd_internal_alb_security_group.this_security_group_id]
  subnets         = data.aws_subnet_ids.web.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name                 = "tg-${var.application}-internal-001"
      backend_protocol     = "HTTP"
      backend_port         = var.fe_service_port
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.fe_health_check_path
        port                = var.fe_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}

#--------------------------------------------
# Internal ALB CloudWatch Merics
#--------------------------------------------
module "internal_alb_metrics" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26"

  load_balancer_id = module.chd_internal_alb.this_lb_id
  target_group_ids = module.chd_internal_alb.target_group_arns

  depends_on = [module.chd_internal_alb]
}
