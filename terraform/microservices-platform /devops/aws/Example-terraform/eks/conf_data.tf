data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = var.remote_bucket_source[var.project]
    region = "us-east-1"
    key    = "terraform/us-east-1/infrastructure_us-east-1_prod.tfstate"
  }
}

data "aws_acm_certificate" "certs" {
  count = length(var.certificate)
  domain   = element(var.certificate, count.index)
  statuses = ["ISSUED"]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.id
}

data "template_file" "worker_user_access" { 
  template = file(var.eks.mapUsers)
}

# HELM 
data "helm_repository" "traefik" {
  name = "traefik"
  url  = "https://containous.github.io/traefik-helm-chart"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

data "aws_route53_zone" "public" {
  name         = var.control_domain_dns
  private_zone = false
}

data "aws_iam_policy_document" "dns_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "${module.eks.worker_iam_role}"
      ]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "dns_rules" {
  statement {
    sid = "GrantModifyAccessToDomains"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.public.zone_id}"
    ]
  }

   statement {
    sid = "GrantListToDomains"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]

    effect = "Allow"

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "cluster_as_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "${module.eks.worker_iam_role}"
      ]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "cluster_as" {
  statement {
    sid = "GetPermForAutoscaleCluster"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    effect = "Allow"

    resources = [
      "*"
    ]
  }
}

data "aws_ssm_parameter" "db_username" { 
  name = "${local.main_prefix}-${var.svc}-username"
}

data "aws_ssm_parameter" "db_password" { 
  name = "${local.main_prefix}-${var.svc}-password"
}

