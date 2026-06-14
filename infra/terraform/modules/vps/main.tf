locals {
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Role      = "mesh-vpn-syncthing-vps"
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu_lts" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "this" {
  cidr_block           = "10.90.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${var.name}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.90.0.0/25"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${var.name}-public"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, {
    Name = "${var.name}-public"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = var.ssh_public_key

  tags = local.tags

  lifecycle {
    precondition {
      condition     = trimspace(var.ssh_public_key) != ""
      error_message = "ssh_public_key must be set when the VPS module is enabled."
    }
  }
}

resource "aws_security_group" "this" {
  name        = var.name
  description = "Public ingress for Headscale/embedded DERP and optional bootstrap SSH"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Headscale coordination and embedded DERP over HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Headscale embedded STUN"
    from_port   = 3478
    to_port     = 3478
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.http_ingress_enabled ? [1] : []

    content {
      description = "Optional ACME HTTP-01 bootstrap"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.ssh_ingress_enabled ? [1] : []

    content {
      description = "Temporary restricted SSH bootstrap"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.admin_ssh_cidr_blocks
    }
  }

  egress {
    description = "Outbound internet access for packages, containers, ACME, S3, and control traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = var.name
  })

  lifecycle {
    precondition {
      condition     = !var.ssh_ingress_enabled || length(var.admin_ssh_cidr_blocks) > 0
      error_message = "admin_ssh_cidr_blocks must contain at least one CIDR when ssh_ingress_enabled is true."
    }
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu_lts.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = aws_key_pair.this.key_name

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = var.root_volume_size_gb
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = merge(local.tags, {
    Name = var.name
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = aws_subnet.public.availability_zone
  encrypted         = true
  size              = var.data_volume_size_gb
  type              = "gp3"

  tags = merge(local.tags, {
    Name = "${var.name}-data"
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "data" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.this.id
  volume_id   = aws_ebs_volume.data.id
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(local.tags, {
    Name = var.name
  })
}

resource "aws_eip_association" "this" {
  allocation_id = aws_eip.this.id
  instance_id   = aws_instance.this.id
}

resource "aws_route53_record" "vpn" {
  zone_id = var.hosted_zone_id
  name    = var.vpn_hostname
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}
