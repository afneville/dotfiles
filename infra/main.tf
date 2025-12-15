resource "aws_route53_record" "root_mx" {
  name                             = "afneville.com"
  records                          = ["10 mail.protonmail.ch", "20 mailsec.protonmail.ch"]
  set_identifier                   = null
  ttl                              = 300
  type                             = "MX"
  zone_id                          = var.hosted_zone_id
}

resource "aws_route53_record" "root_txt" {
  name                             = "afneville.com"
  records                          = ["google-site-verification=QkSK5uRI2vJcryBQW2EQTG_QTG-QDI7t5kl7JXo08ew", "protonmail-verification=bc935017ba0f549f036fdbfb92e0d3d876b3bf89", "v=spf1 include:_spf.protonmail.ch mx ~all"]
  set_identifier                   = null
  ttl                              = 300
  type                             = "TXT"
  zone_id                          = var.hosted_zone_id
}
