data "aws_route53_zone" "zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = var.ttl
  records = [var.ipv4_address]
}
