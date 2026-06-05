variable "name" {
  description = "Name prefix for VPS resources."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for the public VPN DNS record."
  type        = string
}

variable "vpn_hostname" {
  description = "Public DNS hostname for Headscale coordination and embedded DERP."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the VPS."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key material for administrative access."
  type        = string
  sensitive   = true
}

variable "ssh_ingress_enabled" {
  description = "Whether to expose SSH ingress from admin_ssh_cidr_blocks."
  type        = bool
}

variable "admin_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to reach SSH when ssh_ingress_enabled is true."
  type        = list(string)
}

variable "http_ingress_enabled" {
  description = "Whether to expose TCP 80, for example during ACME HTTP-01 bootstrap."
  type        = bool
}

variable "data_volume_size_gb" {
  description = "Size of the encrypted gp3 data volume attached to the VPS."
  type        = number
}

variable "root_volume_size_gb" {
  description = "Size of the encrypted gp3 root volume."
  type        = number
}

variable "tags" {
  description = "Additional tags for VPS resources."
  type        = map(string)
  default     = {}
}
