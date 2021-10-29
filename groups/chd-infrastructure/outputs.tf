output "chd_bep_address_internal" {
  value = aws_route53_record.nlb_backend.fqdn
}
