data "aws_network_interface" "nlb_fe_internal" {
  for_each = data.aws_subnet_ids.web.ids

  filter {
    name   = "description"
    values = ["ELB ${module.nlb_fe_internal.this_lb_arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

module "nlb_fe_internal" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "nlb-${var.application}-fe-internal-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "network"
  enable_deletion_protection = true

  subnets                    = data.aws_subnet_ids.web.ids

  http_tcp_listeners = concat([
    {
      port               = 21
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 1
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 2
    }
  ],
  local.chd_fe_ftp_passive_listeners)

  target_groups = [
    {
      name                 = "tg-${var.application}-fe-internal-ftp-001"
      backend_protocol     = "TCP"
      backend_port         = 21
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
    },
    {
      name                 = "tg-${var.application}-fe-internal-alb-001"
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "alb"
      targets = [
        {
          target_id        = module.chd_internal_alb.this_lb_arn
          port             = 80
        }
      ]
      health_check = {
        enabled             = true
        interval            = 30
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "HTTP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
    {
      name                 = "tg-${var.application}-fe-internal-alb-002"
      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "alb"
      targets = [
        {
          target_id        = module.chd_internal_alb.this_lb_arn
          port             = 443
        }
      ]
      health_check = {
        enabled             = true
        interval            = 30
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "HTTP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    }
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}
