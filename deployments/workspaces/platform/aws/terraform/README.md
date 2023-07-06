<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.36.1 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.36.1 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | ~> 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.instance-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidrs"></a> [access\_cidrs](#input\_access\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_access_security_groups"></a> [access\_security\_groups](#input\_access\_security\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_egress_cidrs"></a> [egress\_cidrs](#input\_egress\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_grpc_port"></a> [grpc\_port](#input\_grpc\_port) | n/a | `number` | `3282` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | n/a | `number` | `3000` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3.large"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | name of existing ssh key to enable access to workspaces server | `string` | `null` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_termination_protection"></a> [termination\_protection](#input\_termination\_protection) | n/a | `bool` | `false` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | n/a | `number` | `20` | no |
| <a name="input_workspaces_name"></a> [workspaces\_name](#input\_workspaces\_name) | n/a | `string` | `"workspaces"` | no |
| <a name="input_workspaces_registry"></a> [workspaces\_registry](#input\_workspaces\_registry) | n/a | `string` | `"teradata"` | no |
| <a name="input_workspaces_repository"></a> [workspaces\_repository](#input\_workspaces\_repository) | n/a | `string` | `"regulus-workspaces"` | no |
| <a name="input_workspaces_version"></a> [workspaces\_version](#input\_workspaces\_version) | n/a | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_grpc_access_workspaces"></a> [private\_grpc\_access\_workspaces](#output\_private\_grpc\_access\_workspaces) | n/a |
| <a name="output_private_http_access_workspaces"></a> [private\_http\_access\_workspaces](#output\_private\_http\_access\_workspaces) | n/a |
| <a name="output_private_ip_workspaces"></a> [private\_ip\_workspaces](#output\_private\_ip\_workspaces) | n/a |
| <a name="output_public_grpc_access_workspaces"></a> [public\_grpc\_access\_workspaces](#output\_public\_grpc\_access\_workspaces) | n/a |
| <a name="output_public_http_access_workspaces"></a> [public\_http\_access\_workspaces](#output\_public\_http\_access\_workspaces) | n/a |
| <a name="output_public_ip_workspaces"></a> [public\_ip\_workspaces](#output\_public\_ip\_workspaces) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
| <a name="output_ssh_connection"></a> [ssh\_connection](#output\_ssh\_connection) | n/a |
<!-- END_TF_DOCS -->