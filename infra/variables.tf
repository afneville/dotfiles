variable "hosted_zone_id" {
  description = "The ID of the hosted zone."
  type        = string
}

variable "hosted_zone" {
  description = "The root domain name."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket for content."
  type        = string
}

variable "domain_names" {
  description = "The domain aliases for the CloudFront distribution."
  type        = list(string)
}

