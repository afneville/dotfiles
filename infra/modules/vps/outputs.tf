output "elastic_ip" {
  description = "Elastic IP address assigned to the VPS."
  value       = aws_eip.this.public_ip
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "vpn_hostname" {
  description = "Public VPN coordination hostname."
  value       = aws_route53_record.vpn.fqdn
}

output "security_group_id" {
  description = "VPS security group ID."
  value       = aws_security_group.this.id
}

output "data_volume_id" {
  description = "Encrypted data EBS volume ID."
  value       = aws_ebs_volume.data.id
}

output "ssh_command" {
  description = "SSH command hint for the default Ubuntu user."
  value       = "ssh ubuntu@${aws_eip.this.public_ip}"
}
