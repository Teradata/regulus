data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  # TODO ALLOW specifying role name or prefix
  # TODO ALLOW using exising role
  name               = join("-", [var.workspaces_name, "role"])
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  # TODO ADD permissions_boundary
}

resource "aws_iam_instance_profile" "this" {
  name = join("-", [var.workspaces_name, "secrets-access"])
  role = aws_iam_role.this.name
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "iam:PassRole",
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteInstanceProfile",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagRole",
      "iam:TagInstanceProfile",
      "ec2:TerminateInstances",
      "ec2:RunInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ModifyInstanceAttribute",
      "ec2:ImportKeyPair",
      "ec2:DescribeVpcs",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribePlacementGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeAccountAttributes",
      "ec2:DeleteSecurityGroup",
      "ec2:DeletePlacementGroup",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteKeyPair",
      "ec2:CreateTags",
      "ec2:CreateSecurityGroup",
      "ec2:CreatePlacementGroup",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:CreateLaunchTemplate",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:TagResource"
    ]

    resources = ["*"] # TODO increase retrictions
  }
}

resource "aws_iam_role_policy" "this" {
  name   = join("-", [var.workspaces_name, "ec2-policy"])
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}

