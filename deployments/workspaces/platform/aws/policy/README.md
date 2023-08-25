# Example IAM Policies 

If the account deploying workspaces does not have sufficient IAM permissions to create IAM roles or IAM policies,
roles and policies can be defined prior to deployment and passed into the workspaces template.

For workspaces, a IAM role would need the following policies:
## [workspaces-with-iam-role-permissions.json](workspaces-with-iam-role-permissions.json)
which includes the permissions needed to create regulus instances and grants workspaces the
permissions to create cluster specific IAM roles and policies for the Regulus systems it 
will deploy.
```
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
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
              "secretsmanager:PutSecretValue"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
}
```
If account restrictions do will not allow workspaces to create IAM Roles and IAM policies,
Then workspaces should also be provided a IAM role with a Policy to pass to the Regulus clusters.
In this case, a modifed Workspaces policy can be used which does not include permissions to
create IAM Roles or IAM Policies.

## [workspaces-without-iam-role-permissions.json](workspaces-without-iam-role-permissions.json)
which includes the permissions needed to create regulus instances
```
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "iam:PassRole",
              "iam:AddRoleToInstanceProfile",
              "iam:CreateInstanceProfile",
              "iam:DeleteInstanceProfile",
              "iam:GetInstanceProfile",
              "iam:GetRole",
              "iam:GetRolePolicy",
              "iam:ListAttachedRolePolicies",
              "iam:ListInstanceProfilesForRole",
              "iam:ListRolePolicies",
              "iam:PutRolePolicy",
              "iam:RemoveRoleFromInstanceProfile",
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
              "secretsmanager:PutSecretValue"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
}
```

If you will be using AWS Session Manager to connect to the Workspaces instance, an additional policy should be attached to
the IAM Role used for workspaces.

## [workspaces-session-manager.json](workspaces-session-manager.json)
which includes the permissions needed to interact with Session Manager
```
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "ssm:DescribeAssociation",
              "ssm:GetDeployablePatchSnapshotForInstance",
              "ssm:GetDocument",
              "ssm:DescribeDocument",
              "ssm:GetManifest",
              "ssm:ListAssociations",
              "ssm:ListInstanceAssociations",
              "ssm:PutInventory",
              "ssm:PutComplianceItems",
              "ssm:PutConfigurePackageResult",
              "ssm:UpdateAssociationStatus",
              "ssm:UpdateInstanceAssociationStatus",
              "ssm:UpdateInstanceInformation"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
          "Action": [
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
          "Action": [
              "ec2messages:AcknowledgeMessage",
              "ec2messages:DeleteMessage",
              "ec2messages:FailMessage",
              "ec2messages:GetEndpoint",
              "ec2messages:GetMessages",
              "ec2messages:SendReply"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
}
```

If passing the Regulus Role to new regulus clusters instead of allowing workspaces to create the cluster specific role,
the following policy can be used as a starting point to template your desired policy.
## [regulus.json](regulus.json)

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "secretsmanager:GetSecretValue",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:compute-engine/*"
      ]
    }
  ]
}

```

Note, when workspaces creates policies for regulus, they are restricted to the form of
```
"Resource": [ "arn:aws:secretsmanager:<REGULUS_REGION>:<REGULUS_ACCOUNT_ID>:secret:compute-engine/<REGULUS_CLUSTER_NAME>/<SECRET_NAME>"]
```
If providing a IAM Role and Policy, the cluster name will not be predictable, so some level of wildcarding will be needed in the replacement policy,

such as 
```
"arn:aws:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:compute-engine/*"
or
"arn:aws:secretsmanager:<REGION>:111111111111:secret:compute-engine/*"
or
"arn:aws:secretsmanager:us-west-2:111111111111:secret:compute-engine/*"
```
