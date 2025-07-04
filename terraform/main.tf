data "aws_ssm_parameter" "eks_worker_ami" {
  name = "/aws/service/eks/optimized-ami/1.29/amazon-linux-2/recommended/image_id"
}
# Launch Template for Node Group
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-node-lt"
  image_id      = data.aws_ssm_parameter.eks_worker_ami.value
  instance_type = "t3.medium"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.eks_node_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node"
    }
  }
}


# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_iam_role_policy_attachment.vpc_cni_policy
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_launch_template.eks_nodes,
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.ecr_readonly,
    aws_iam_role_policy_attachment.vpc_cni_policy
  ]
}