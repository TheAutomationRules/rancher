# Creacion de un  Cluster de Rancher 2 RKE
resource "rancher2_cluster" "rancher-cluster" {
  name = "rancher-cluster"
  description = "Rancher2 Test Cluster"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}
# Creacion de credenciales de Servicios Cloud (AWS)
resource "rancher2_cloud_credential" "aws-credentials" {
  name = "aws-credentials"
  description= "AWS Credentials Terraform"
  amazonec2_credential_config {
    default_region = "eu-central-1"
    access_key = data.vault_generic_secret.access_key.data["access_key"]
    secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
  }
}
# Creacion de un Template para Nodos de Rancher
resource "rancher2_node_template" "template-t3a-medium" {
  name = "template-t3a-medium"
  description = "Rancher Node Template t3a.medium"
  cloud_credential_id = rancher2_cloud_credential.aws-credentials.id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.docker_version}.sh"
  amazonec2_config {
    ami =  data.aws_ami.ubuntu.id
    region = "eu-central-1"
    security_group = [data.aws_security_group.rancher.name]
    subnet_id = data.aws_subnet.eu-central-1-1a.id
    vpc_id = data.aws_vpc.vpc-id-staging.id
    zone = "a"
    instance_type = "t3a.medium"
    #iam_instance_profile = var.iam_instance_profile
    #private_address_only = true
  }
}
# Creacion de un Pool de Nodos de Rancher
resource "rancher2_node_pool" "foo" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-cluster-node"
  hostname_prefix =  "rancher-cluster-0"
  node_template_id = rancher2_node_template.template-t3a-medium.id
  quantity = 3
  control_plane = true
  etcd = true
  worker = true
}
# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename        = "${path.module}/.kube/kube_config.yaml"
  content         = rancher2_cluster.rancher-cluster.kube_config
  file_permission = "0600"
  depends_on = [rancher2_cluster.rancher-cluster]
}