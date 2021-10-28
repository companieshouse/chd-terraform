data "aws_network_interface" "nlb" {
  for_each = data.aws_subnet_ids.application.ids

  filter {
    name   = "description"
    values = ["ELB ${module.backend_nlb.this_lb_arn_suffix}"]

  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

module "backend_nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "nlb-${var.application}-bep-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "network"
  enable_deletion_protection = true

  subnets         = data.aws_subnet_ids.application.ids

  http_tcp_listeners = [
    {
      port               = 631
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name                 = "tg-${var.application}-bep-001"
      backend_protocol     = "TCP"
      backend_port         = 631
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        port                = 631
        healthy_threshold   = 3
        unhealthy_threshold = 3
        protocol            = "TCP"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-BE-Support"
    )
  )
}
