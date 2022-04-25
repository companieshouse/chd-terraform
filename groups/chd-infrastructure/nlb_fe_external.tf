data "aws_network_interface" "nlb_fe_external" {
  for_each = data.aws_subnet_ids.public.ids

  filter {
    name   = "description"
    values = ["ELB ${module.nlb_fe_external.this_lb_arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

module "nlb_fe_external" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "nlb-${var.application}-fe-external-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = false
  load_balancer_type         = "network"
  enable_deletion_protection = true

  subnets                    = data.aws_subnet_ids.public.ids

  http_tcp_listeners = [
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
  ]

  target_groups = [
    {
      name                 = "tg-${var.application}-fe-external-ftp-001"
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
      name                 = "tg-${var.application}-fe-external-alb-001"
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "alb"
      targets = [
        {
          target_id        = module.chd_external_alb.this_lb_arn
          port             = 80
        }
      ]
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
    {
      name                 = "tg-${var.application}-fe-external-alb-002"
      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "alb"
      targets = [
        {
          target_id        = module.chd_external_alb.this_lb_arn
          port             = 443
        }
      ]
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
