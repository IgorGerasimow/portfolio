resource "aws_iam_role" "dns" {
  name        = "${module.eks.name_prefix}-ex-dns"
  description = "Role that can be assumed by external-dns"
  assume_role_policy = data.aws_iam_policy_document.dns_assume.json
}

resource "aws_iam_policy" "dns" {
  name        = "${module.eks.name_prefix}-ex-dns"
  description = "Grant permissions for external-dns"
  policy      = data.aws_iam_policy_document.dns_rules.json
}

resource "aws_iam_role_policy_attachment" "dns" {
  role       = aws_iam_role.dns.name
  policy_arn = aws_iam_policy.dns.arn

}

resource "aws_iam_role" "cluster_as" {
  name        = "${module.eks.name_prefix}-eks-ca"
  description = "Role that can be assumed by cluster autoscaler"
  assume_role_policy = data.aws_iam_policy_document.cluster_as_assume.json
}

resource "aws_iam_policy" "cluster_as" {
  name        = "${module.eks.name_prefix}-eks-ca"
  description = "Grant permissions for cluster autoscaler"
  policy      = data.aws_iam_policy_document.cluster_as.json
}

resource "aws_iam_role_policy_attachment" "cluster_as" {
  role       = aws_iam_role.cluster_as.name
  policy_arn = aws_iam_policy.cluster_as.arn
}