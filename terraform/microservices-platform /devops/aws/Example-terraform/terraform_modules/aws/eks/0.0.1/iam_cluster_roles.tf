resource "aws_iam_role" "eks_master" {
  count = var.enabled && var.master_role_arn == "" ? 1 : 0
  name = "${local.main_prefix}-${var.svc}-master"
  assume_role_policy = data.aws_iam_policy_document.eks_master.json
}
 
resource "aws_iam_role_policy_attachment" "eks_master_AmazonEKSClusterPolicy" {
  count = var.enabled && var.master_role_arn == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_master[0].name
}
 
resource "aws_iam_role_policy_attachment" "eks_master_AmazonEKSServicePolicy" {
  count = var.enabled && var.master_role_arn == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_master[0].name
}

############################



resource "aws_iam_policy" "eks_worker_assume_other" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  name        = "${local.main_prefix}-${var.svc}-eks-assume"
  path        = "/"
  description = "Policy for assume other role"
  policy = data.aws_iam_policy_document.eks_worker_policy_assume.json
}

resource "aws_iam_role" "eks_worker" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  name = "${local.main_prefix}-${var.svc}-worker"
  assume_role_policy = data.aws_iam_policy_document.eks_worker_role.json
}

resource "aws_iam_role_policy_attachment" "eks_worker_assume_other" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  policy_arn = aws_iam_policy.eks_worker_assume_other[0].arn
  role       = aws_iam_role.eks_worker[0].name
}
 
resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKSWorkerNodePolicy" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker[0].name
}
 
resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEKS_CNI_Policy" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker[0].name
}
 
resource "aws_iam_role_policy_attachment" "eks_worker_AmazonEC2ContainerRegistryReadOnly" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker[0].name
}

resource "aws_iam_instance_profile" "eks_worker" {
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  name = "${local.main_prefix}-${var.svc}-worker"
  role = aws_iam_role.eks_worker[0].name
  depends_on = [aws_iam_role.eks_worker]
}


