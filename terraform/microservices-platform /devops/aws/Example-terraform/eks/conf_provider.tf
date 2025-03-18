provider "aws" {
  version = "2.54"
  region  = var.region
}

provider "kubernetes" {
  version = "1.11.3"
  config_path = module.eks.kube_config_file
}
# Why config, cause when you delete it you have errors 
provider "helm" {
  version = "1.1.1"
  kubernetes {
    # host                   = module.eks.endpoint
    host                   = module.eks.endpoint
    # cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
    # token                  = data.aws_eks_cluster_auth.cluster_auth.token
    # load_config_file       = false
    config_path = module.eks.kube_config_file
  }

}

terraform {
  backend "s3" {
    region = var.region
  }
}
