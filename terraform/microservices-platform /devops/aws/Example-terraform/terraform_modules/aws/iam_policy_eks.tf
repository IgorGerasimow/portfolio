# Kube inner releated role 
data "aws_iam_policy_document" "alb_ingress" {
  statement {
      actions = [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate"
      ]
      resources = ["*"]
  }
  statement { 
    actions = [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "iam:GetServerCertificate",
      "iam:ListServerCertificates"
    ]
    resources = ["*"]
  }
  statement { 
    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "tag:GetResources",
      "tag:TagResources"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "waf:GetWebACL"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "alb_ingress_assume" {
  statement {
    actions = ["sts:AssumeRole"]
     principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.eks_worker.arn}"]
    }
  }
}

resource "aws_iam_role" "alb_ingress" {
  name        = "${var.name_platform}-${var.env}-${local.short_region}-${var.service}-worker-alb-ingress"
  assume_role_policy = "${data.aws_iam_policy_document.alb_ingress_assume.json}"
}

resource "aws_iam_policy" "alb_ingress" {
  name        = "${var.name_platform}-${var.env}-${local.short_region}-${var.service}-policy-alb-ingress"
  path        = "/"
  description = "Policy for balancer ingress controller"
  policy = "${data.aws_iam_policy_document.alb_ingress.json}"
}

resource "aws_iam_role_policy_attachment" "alb_ingress" {
  policy_arn = "${aws_iam_policy.alb_ingress.arn}"
  role       = "${aws_iam_role.alb_ingress.name}"
}

data "aws_iam_policy_document" "asg_access" {
  statement {
      actions = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ]
      resources = ["*"]
  }
}

data "aws_iam_policy_document" "asg_access_role" {
  statement {
    actions = ["sts:AssumeRole"]
     principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.eks_worker.arn}"]
    }
  }
}

resource "aws_iam_role" "asg_role" {
  name        = "${var.name_platform}-${var.env}-${local.short_region}-${var.service}-ca-kube"
  assume_role_policy = "${data.aws_iam_policy_document.asg_access_role.json}"
}

resource "aws_iam_policy" "asg_policy" {
  name        = "${var.name_platform}-${var.env}-${local.short_region}-${var.service}-ca-policy-kube"
  path        = "/"
  description = "Policy for balancer ingress controller"
  policy = "${data.aws_iam_policy_document.asg_access.json}"
}

resource "aws_iam_role_policy_attachment" "asg_attachment" {
  role       = "${aws_iam_role.asg_role.name}"
  policy_arn = "${aws_iam_policy.asg_policy.arn}"
}