output "chd_frontend_address_internal" {
  value = aws_route53_record.chd_alb_internal.fqdn
}

output "chd_bep_address_internal" {
  value = aws_route53_record.nlb_backend.fqdn
}
