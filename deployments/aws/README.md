# Workspaces and Jupyter Deployments for AWS

## Cloud Formations Templates

### Deployent via CLI

### Deployment Commands

aws cloudformation create-stack --stack-name predeployed \
  --template-body file:///Users/jack.lauritsen/Code/Teradata-Public/regulus/deployments/workspaces/platform/aws/cloud-formation-template/workspaces-and-jupyter.yaml \
  --parameters file:///Users/jack.lauritsen/Code/Teradata-Public/regulus/deployments/workspaces/platform/aws/cloud-formation-template/parameters.json \
  --tags Key=ThisIsAKey,Value=AndThisIsAValue \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

aws cloudformation create-stack --stack-name all-in-one \
  --template-body file://deployments/aws/all-in-one.yaml \
  --parameters file://deployments/aws/parameters/all-in-one.json \
  --tags Key=ThisIsAKey,Value=AndThisIsAValue \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

StackId: arn:aws:cloudformation:us-west-2:989207584854:stack/predeployed/fbeadf00-5891-11ee-8a2b-026dfbaa8503

# -----------------------------------------------------

aws cloudformation deploy --stack-name newclideployed \
  --template-file /Users/jack.lauritsen/Code/Teradata-Public/regulus/deployments/workspaces/platform/aws/cloud-formation-template/workspaces-and-jupyter.yaml \
  --parameter-overrides file:///Users/jack.lauritsen/Code/Teradata-Public/regulus/deployments/workspaces/platform/aws/cloud-formation-template/parameters.json \
  --tags ThisIsAKey=ThisIsAValue YetAnotherKey=WithANewValue \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

# -----------------------------------------------------


  --parameter-overrides \
    AccessCIDR=104.28.85.232/32 \
    AvailabilityZone=us-west-2c \
    JupyterToken=G041t \
    LoadBalancerScheme=internet-facing \
    LoadBalancing=NetworkLoadBalancer \
    PersistentVolumeDeletionPolicy=Retain \
    PersistentVolumeSize="20" \
    RootVolumeSize="20" \
    Session="true" \
    Private="true" \
    Subnet=subnet-0110919a1c3044611 \
    UsePersistentVolume=None \
    Vpc=vpc-0727eff21a8b49e0c \
    WorkspacesName=test-cli-3 \
    TerminationProtection="false" \
    IamRole="" \
    KeyName="" \

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
