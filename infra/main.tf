resource "aws_route53_record" "root_mx" {
  name           = "afneville.com"
  records        = ["1 SMTP.GOOGLE.COM."]
  set_identifier = null
  ttl            = 300
  type           = "MX"
  zone_id        = var.hosted_zone_id
}

resource "aws_route53_record" "root_txt" {
  name = "afneville.com"
  records = [
    "google-site-verification=QkSK5uRI2vJcryBQW2EQTG_QTG-QDI7t5kl7JXo08ew",
    "google-site-verification=3SoeOJt1aWjNOOFRYqDNFNPM9nVybTIae5sdGToJH7M",
    "protonmail-verification=bc935017ba0f549f036fdbfb92e0d3d876b3bf89",
    "v=spf1 include:_spf.google.com ~all"
  ]
  set_identifier = null
  ttl            = 300
  type           = "TXT"
  zone_id        = var.hosted_zone_id
}

resource "aws_route53_record" "root_dmarc" {
  name           = "_dmarc.afneville.com"
  records        = ["v=DMARC1;p=reject"]
  set_identifier = null
  ttl            = 300
  type           = "TXT"
  zone_id        = var.hosted_zone_id
}

# records        = ["v=DMARC1; p=none; rua=mailto:contact@mail.afneville.com, mailto:dmarc@mail.afneville..com; pct=100; adkim=s; aspf=s"]


resource "aws_route53_record" "google_dkim" {
  name           = "google._domainkey.afneville.com"
  records        = ["v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtDVMNZlA4Ck+S3wgdlW5f6AVBV/voTd6mSGy\" \"koUQi4/JvPMkebwk4QIeVXMQkP6zU3zI0uXtv0zxj+8dho8WkRr3i8zft06204t6L\" \"mJGEHbUOnqWoR39SZiO25UCeN8uBHtcfRi5qtOINQNH\" \"jE4y7e9smXt14WjtJPddSL7CSMo8+uTGDZ37QCXSDa0HK\" \"EpPLIZDH8Ojtvjr7tZVzujX4WRW6jto0cq1RmAFngTMoUKuk56o\" \"WXbkxhBGr2/b6CSjrO+I\" \"RZfj6bHubwQbsdqBACaK9X3UghTDmiL3u3cZx\" \"FDfjhCWkZMpjqzglFCX+x9bPf+rniKOnxbkCjVugEODcwIDAQAB"]
  set_identifier = null
  ttl            = 300
  type           = "TXT"
  zone_id        = var.hosted_zone_id
}

module "wkd" {
  source = "git::https://github.com/afneville/cached-bucket-tf.git?ref=v2"

  providers = {
    aws.n-virginia = aws.n-virginia
  }

	hosted_zone = var.hosted_zone
  bucket_name = var.bucket_name
	domain_names = var.domain_names
}
