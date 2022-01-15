# AWS Infrastructure Resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename = "keys/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "keys/id_rsa.pub"
  content = tls_private_key.global_key.public_key_openssh
}

# Temporary key pair used for SSH accesss
resource "aws_key_pair" "rancher_key_pair" {
  key_name_prefix = "test-rancher-"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "sg_staging_eu-central-1_rancher_001"
  description = "Rancher - Security Group"
  vpc_id      = data.aws_vpc.vpc-id-staging.id

  # INGRESS RULES
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTP access from client web browsers to the local user interface and connections from Cloud Data Sense"
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTP access from client web browsers to the local user interface and connections from Cloud Data Sense"
  }

  ingress {
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS traffic to Kubernetes API"
  }

  ingress {
    from_port   = "3260"
    to_port     = "3260"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "iSCSI access through the iSCSI data LIF"
  }

  ingress {
    from_port   = "30000"
    to_port     = "30000"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT K8s Ports Temp"
  }

  ingress {
    from_port   = "30000"
    to_port     = "30000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT K8s Ports Temp"
  }

  ingress {
    from_port   = "8472"
    to_port     = "8472"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel VXLAN overlay networking"
  }

  ingress {
    from_port   = "2380"
    to_port     = "2380"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "etcd peer communication"
  }

  ingress {
    from_port   = "9099"
    to_port     = "9099"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel livenessProbe/readinessProbe"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTPS access from client web browsers to the local user interface"
  }

  ingress {
    from_port   = "179"
    to_port     = "179"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provide 179 Access"
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides ping"
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }

  ingress {
    from_port   = "30000"
    to_port     = "30000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT K8s Ports Temp"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provide SSH"
  }

  ingress {
    from_port   = "10250"
    to_port     = "10250"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubelet"
  }

  ingress {
    from_port   = "2379"
    to_port     = "2379"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "etcd client requests"
  }

  ingress {
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS traffic to Kubernetes API"
  }

  ingress {
    from_port   = "10254"
    to_port     = "10254"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress controller livenessProbe/readinessProbe"
  }

  ingress {
    from_port   = "8500"
    to_port     = "8500"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Vault"
  }

  # EGRESS RULES / ALLOW ALL
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "sg_staging_eu-central-1_rancher_001"
    Terraform = "True"
  }
  depends_on = [aws_key_pair.rancher_key_pair]
}

# AWS EC2 instance for creating a single node RKE cluster and installing the Rancher server
resource "aws_instance" "rancher_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = aws_key_pair.rancher_key_pair.key_name
  subnet_id = data.aws_subnet.eu-central-1-1c.id
  private_ip = var.private_ip
  security_groups = [aws_security_group.rancher_sg_allowall.id]
  #user_data_base64 = base64encode(data.template_file.cloud-init-config.rendered)
  user_data = templatefile(
  join("/", [
    path.module, "user-data/userdata_rancher_server.template"]), {
    docker_version = var.docker_version
    username = var.node_username
  }
  )
  ebs_optimized = true
  root_block_device {
    volume_type = "gp2"
    volume_size = 16
    encrypted = true
    #kms_key_id = data.vault_generic_secret.kms_key_id.data["kms_key_id"]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      "echo 'Rancher Server ready!'",
    ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = var.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name = "rancher-server"
    Creator = "Terraform"
    Role = "Rancher Server"
    Team = "IAC"
    Environment = "Staging"
    Entity = "My Company"
  }
  depends_on = [aws_security_group.rancher_sg_allowall]
}

# Admin Password Generator
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Delay time to Rancher Up
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 300"
  }
  depends_on = [aws_instance.rancher_server]
}

# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  provider   = rancher2.bootstrap
  password   = random_password.password.result
  #password = var.admin_password # Optional Custom Password Var
  depends_on = [
    aws_instance.rancher_server,
    null_resource.delay
  ]
}