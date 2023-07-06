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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_uuid.jupyter_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidrs"></a> [access\_cidrs](#input\_access\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_access_security_groups"></a> [access\_security\_groups](#input\_access\_security\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_egress_cidrs"></a> [egress\_cidrs](#input\_egress\_cidrs) | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | n/a | `number` | `8888` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3.large"` | no |
| <a name="input_jupyter_name"></a> [jupyter\_name](#input\_jupyter\_name) | n/a | `string` | `"jupyter"` | no |
| <a name="input_jupyter_registry"></a> [jupyter\_registry](#input\_jupyter\_registry) | n/a | `string` | `"teradata"` | no |
| <a name="input_jupyter_repository"></a> [jupyter\_repository](#input\_jupyter\_repository) | n/a | `string` | `"regulus-jupyter"` | no |
| <a name="input_jupyter_version"></a> [jupyter\_version](#input\_jupyter\_version) | n/a | `string` | `"latest"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | name of existing ssh key to enable access to jupyter server | `string` | `null` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_http_accessr"></a> [private\_http\_accessr](#output\_private\_http\_accessr) | n/a |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | n/a |
| <a name="output_public_http_access"></a> [public\_http\_access](#output\_public\_http\_access) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
| <a name="output_ssh_connection"></a> [ssh\_connection](#output\_ssh\_connection) | n/a |
<!-- END_TF_DOCS -->