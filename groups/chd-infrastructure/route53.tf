resource "aws_route53_record" "nlb_backend" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}-bep"
  type    = "A"

  alias {
    name                   = module.backend_nlb.this_lb_dns_name
    zone_id                = module.backend_nlb.this_lb_zone_id
    evaluate_target_health = true
  }
}
