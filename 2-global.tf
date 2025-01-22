# # Create Hosted Zones for each region
# resource "aws_route53_zone" "hosted_zones" {
#   for_each = {
#     "new_york"   = var.new_york_config.region
#     "london"     = var.london_config.region
#     "sao_paulo"  = var.sao_paulo_config.region
#     "sydney"     = var.sydney_config.region
#     "hong_kong"  = var.hong_kong_config.region
#     "norcal"     = var.norcal_config.region
#   }

#   name = "${each.key}.${var.domain}"
# }

# # Latency-based Route 53 records for ALBs
# resource "aws_route53_record" "latency_records" {
#   for_each = {
#     "new_york"   = { alb_dns_name = aws_lb.new_york.dns_name, alb_zone_id = aws_lb.new_york.zone_id, region = var.new_york_config.region }
#     "london"     = { alb_dns_name = aws_lb.london.dns_name, alb_zone_id = aws_lb.london.zone_id, region = var.london_config.region }
#     "sao_paulo"  = { alb_dns_name = aws_lb.sao_paulo.dns_name, alb_zone_id = aws_lb.sao_paulo.zone_id, region = var.sao_paulo_config.region }
#     "sydney"     = { alb_dns_name = aws_lb.sydney.dns_name, alb_zone_id = aws_lb.sydney.zone_id, region = var.sydney_config.region }
#     "hong_kong"  = { alb_dns_name = aws_lb.hong_kong.dns_name, alb_zone_id = aws_lb.hong_kong.zone_id, region = var.hong_kong_config.region }
#     "norcal"     = { alb_dns_name = aws_lb.norcal.dns_name, alb_zone_id = aws_lb.norcal.zone_id, region = var.norcal_config.region }
#   }

#   zone_id        = aws_route53_zone.hosted_zones[each.key].id
#   name           = "${each.key}.${var.domain}"
#   type           = "A"
#   set_identifier = each.key
#   region         = each.value.region

#   alias {
#     name                   = each.value.alb_dns_name
#     zone_id                = each.value.alb_zone_id
#     evaluate_target_health = true
#   }
# }

# # Root record pointing to latency-based DNS entries
# resource "aws_route53_record" "root" {
#   zone_id = aws_route53_zone.hosted_zones["new_york"].id  # Use the primary zone
#   name    = var.domain
#   type    = "A"

#   alias {
#     name                   = aws_route53_record.latency_records["new_york"].fqdn
#     zone_id                = aws_route53_zone.hosted_zones["new_york"].id
#     evaluate_target_health = true
#   }
# }
