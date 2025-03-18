provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
  # host                   = aws_eks_cluster.this[0].endpoint
  # cluster_ca_certificate = base64decode(aws_eks_cluster.this[0].certificate_authority.0.data)
  # token                  = data.aws_eks_cluster_auth.cluster_auth[0].token
  # load_config_file       = false
}

data "template_file" "kube_config" { 
  count = var.enabled ? 1 : 0
  template = "${file("${path.module}/templates/kubeConfig.yml")}"
  vars = { 
    master_endpoint = "${aws_eks_cluster.this[0].endpoint}"
    certificate_authority = "${aws_eks_cluster.this[0].certificate_authority.0.data}"
    cluster_name = aws_eks_cluster.this[0].id
  }
}


resource "local_file" "kubeconfig" {
  # HACK: depends_on for the helm provider
  # Passing provider configuration value via a local_file
  depends_on = [aws_eks_cluster.this]
  content    = data.template_file.kube_config[0].rendered
  filename   = "/tmp/k8s_cluster_config-${var.project}-${var.svc}-${var.env}"
}