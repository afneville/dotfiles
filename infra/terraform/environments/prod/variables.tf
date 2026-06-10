variable "hosted_zone_id" {
  description = "The ID of the hosted zone."
  type        = string
}

variable "hosted_zone" {
  description = "The root domain name."
  type        = string
}

variable "wkd_bucket_name" {
  description = "The name of the S3 bucket for content."
  type        = string
}

variable "wkd_domain_names" {
  description = "The domain aliases for the CloudFront distribution."
  type        = list(string)
}

variable "vps_name" {
  description = "Name prefix for VPS resources."
  type        = string
  default     = "personal-vps"
}

variable "vps_vpn_hostname" {
  description = "Public DNS hostname for Headscale coordination and embedded DERP."
  type        = string
  default     = ""
}

variable "vps_instance_type" {
  description = "EC2 instance type for the VPS."
  type        = string
  default     = "t3.large"
}

variable "vps_ssh_public_key" {
  description = "Public SSH key material for administrative access. Overrides vps_ssh_public_key_file when set."
  type        = string
  default     = ""
  sensitive   = true
}

variable "vps_ssh_public_key_file" {
  description = "Path to a public SSH key file for administrative access. This is read when vps_ssh_public_key is empty."
  type        = string
  default     = "key.pub"
}

variable "vps_ssh_ingress_enabled" {
  description = "Whether to expose SSH ingress from vps_admin_ssh_cidr_blocks."
  type        = bool
  default     = false
}

variable "vps_admin_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to reach SSH when vps_ssh_ingress_enabled is true."
  type        = list(string)
  default     = []
}

variable "vps_http_ingress_enabled" {
  description = "Whether to expose TCP 80, for example during ACME HTTP-01 bootstrap."
  type        = bool
  default     = false
}

variable "vps_data_volume_size_gb" {
  description = "Size of the encrypted gp3 data volume attached to the VPS."
  type        = number
  default     = 100
}

variable "vps_root_volume_size_gb" {
  description = "Size of the encrypted gp3 root volume."
  type        = number
  default     = 20
}
