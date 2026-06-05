output "vps_elastic_ip" {
  description = "Elastic IP address assigned to the VPS."
  value       = module.vps.elastic_ip
}

output "vps_instance_id" {
  description = "EC2 instance ID for the VPS."
  value       = module.vps.instance_id
}

output "vps_vpn_hostname" {
  description = "Public VPN coordination hostname."
  value       = module.vps.vpn_hostname
}

output "vps_security_group_id" {
  description = "VPS security group ID."
  value       = module.vps.security_group_id
}

output "vps_data_volume_id" {
  description = "Encrypted data EBS volume ID."
  value       = module.vps.data_volume_id
}

output "vps_ssh_command" {
  description = "SSH command hint for the default Ubuntu user."
  value       = module.vps.ssh_command
}
