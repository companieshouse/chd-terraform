<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0, < 6.0.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | >= 2.0, < 3.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0, < 6.0.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | >= 2.0, < 3.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend_nlb"></a> [backend\_nlb](#module\_backend\_nlb) | terraform-aws-modules/alb/aws | 8.7.0 |
| <a name="module_bep_asg"></a> [bep\_asg](#module\_bep\_asg) | git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling | tags/1.0.360 |
| <a name="module_chd_bep_asg_security_group"></a> [chd\_bep\_asg\_security\_group](#module\_chd\_bep\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_chd_bep_profile"></a> [chd\_bep\_profile](#module\_chd\_bep\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.360 |
| <a name="module_chd_external_alb"></a> [chd\_external\_alb](#module\_chd\_external\_alb) | terraform-aws-modules/alb/aws | 8.7.0 |
| <a name="module_chd_external_alb_security_group"></a> [chd\_external\_alb\_security\_group](#module\_chd\_external\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_chd_fe_asg_security_group"></a> [chd\_fe\_asg\_security\_group](#module\_chd\_fe\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_chd_fe_profile"></a> [chd\_fe\_profile](#module\_chd\_fe\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.360 |
| <a name="module_chd_internal_alb"></a> [chd\_internal\_alb](#module\_chd\_internal\_alb) | terraform-aws-modules/alb/aws | 8.7.0 |
| <a name="module_chd_internal_alb_security_group"></a> [chd\_internal\_alb\_security\_group](#module\_chd\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_cloudwatch_sns_notifications"></a> [cloudwatch\_sns\_notifications](#module\_cloudwatch\_sns\_notifications) | terraform-aws-modules/sns/aws | 6.2.1 |
| <a name="module_external_alb_alarms"></a> [external\_alb\_alarms](#module\_external\_alb\_alarms) | git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms | tags/1.0.357 |
| <a name="module_fe_asg"></a> [fe\_asg](#module\_fe\_asg) | git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling | tags/1.0.360 |
| <a name="module_internal_alb_alarms"></a> [internal\_alb\_alarms](#module\_internal\_alb\_alarms) | git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms | tags/1.0.357 |
| <a name="module_nlb_fe_external"></a> [nlb\_fe\_external](#module\_nlb\_fe\_external) | terraform-aws-modules/alb/aws | 8.7.0 |
| <a name="module_nlb_fe_internal"></a> [nlb\_fe\_internal](#module\_nlb\_fe\_internal) | terraform-aws-modules/alb/aws | 8.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_schedule.bep-schedule-start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.bep-schedule-stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.fe-schedule-start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.fe-schedule-stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_log_group.chd_bep](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.chd_fe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_key_pair.chd_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.chd_frontend_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.nlb_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ssm_parameter.parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.chd_bep_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.chd_fe_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_network_interface.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.nlb_fe_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_network_interface.nlb_fe_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.identity_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.bep_userdata_config](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [cloudinit_config.fe_userdata_config](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [template_file.bep_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.bulkdata_cron_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.chd_cron_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.fe_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.finance_fstab_entry](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chd_bep_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chd_ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chd_fe_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.s3_releases](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.test_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_bep_ami_name"></a> [bep\_ami\_name](#input\_bep\_ami\_name) | Name of the AMI to use in the BEP Auto Scaling configuration | `string` | `"chd-*"` | no |
| <a name="input_bep_app_release_version"></a> [bep\_app\_release\_version](#input\_bep\_app\_release\_version) | Version of the application to download for deployment to backend server(s) | `string` | n/a | yes |
| <a name="input_bep_asg_desired_capacity"></a> [bep\_asg\_desired\_capacity](#input\_bep\_asg\_desired\_capacity) | The desired capacity of the BEP ASG | `number` | n/a | yes |
| <a name="input_bep_asg_max_size"></a> [bep\_asg\_max\_size](#input\_bep\_asg\_max\_size) | The max size of the BEP ASG | `number` | n/a | yes |
| <a name="input_bep_asg_min_size"></a> [bep\_asg\_min\_size](#input\_bep\_asg\_min\_size) | The min size of the BEP ASG | `number` | n/a | yes |
| <a name="input_bep_asg_schedule_start"></a> [bep\_asg\_schedule\_start](#input\_bep\_asg\_schedule\_start) | Schedule an auto-start on the BEP ASG | `bool` | `false` | no |
| <a name="input_bep_asg_schedule_stop"></a> [bep\_asg\_schedule\_stop](#input\_bep\_asg\_schedule\_stop) | Schedule an auto-stop on the BEP ASG | `bool` | `false` | no |
| <a name="input_bep_cw_logs"></a> [bep\_cw\_logs](#input\_bep\_cw\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_bep_default_log_group_retention_in_days"></a> [bep\_default\_log\_group\_retention\_in\_days](#input\_bep\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_bep_instance_size"></a> [bep\_instance\_size](#input\_bep\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_bep_mount_finance_nfs_share"></a> [bep\_mount\_finance\_nfs\_share](#input\_bep\_mount\_finance\_nfs\_share) | Defines whether the finance share should be mounted | `bool` | `false` | no |
| <a name="input_enable_sns_topic"></a> [enable\_sns\_topic](#input\_enable\_sns\_topic) | A boolean value to alter deployment of an SNS topic for CloudWatch actions | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_fe_access_cidrs"></a> [fe\_access\_cidrs](#input\_fe\_access\_cidrs) | List of additional CIDRs requiring access via the internal ALB | `list(any)` | `[]` | no |
| <a name="input_fe_ami_name"></a> [fe\_ami\_name](#input\_fe\_ami\_name) | Name of the AMI to use in the Frontend Auto Scaling configuration | `string` | `"chd-*"` | no |
| <a name="input_fe_app_release_version"></a> [fe\_app\_release\_version](#input\_fe\_app\_release\_version) | Version of the application to download for deployment to frontend server(s) | `string` | n/a | yes |
| <a name="input_fe_asg_desired_capacity"></a> [fe\_asg\_desired\_capacity](#input\_fe\_asg\_desired\_capacity) | The desired capacity of the FE ASG | `number` | n/a | yes |
| <a name="input_fe_asg_max_size"></a> [fe\_asg\_max\_size](#input\_fe\_asg\_max\_size) | The max size of the FE ASG | `number` | n/a | yes |
| <a name="input_fe_asg_min_size"></a> [fe\_asg\_min\_size](#input\_fe\_asg\_min\_size) | The min size of the FE ASG | `number` | n/a | yes |
| <a name="input_fe_asg_schedule_start"></a> [fe\_asg\_schedule\_start](#input\_fe\_asg\_schedule\_start) | Schedule an auto-start on the FE ASG | `bool` | `false` | no |
| <a name="input_fe_asg_schedule_stop"></a> [fe\_asg\_schedule\_stop](#input\_fe\_asg\_schedule\_stop) | Schedule an auto-stop on the FE ASG | `bool` | `false` | no |
| <a name="input_fe_cw_logs"></a> [fe\_cw\_logs](#input\_fe\_cw\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_fe_default_log_group_retention_in_days"></a> [fe\_default\_log\_group\_retention\_in\_days](#input\_fe\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_fe_domain_name"></a> [fe\_domain\_name](#input\_fe\_domain\_name) | Domain name of the ACM certificate used for the external ALB | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_fe_ftp_ext_passive_ports_end"></a> [fe\_ftp\_ext\_passive\_ports\_end](#input\_fe\_ftp\_ext\_passive\_ports\_end) | The ending port that will define the range of ports used for FTP passive mode on the External FTP server | `number` | `60470` | no |
| <a name="input_fe_ftp_ext_passive_ports_start"></a> [fe\_ftp\_ext\_passive\_ports\_start](#input\_fe\_ftp\_ext\_passive\_ports\_start) | The starting port that will define the range of ports used for FTP passive mode on the External FTP server | `number` | `60451` | no |
| <a name="input_fe_ftp_int_passive_ports_end"></a> [fe\_ftp\_int\_passive\_ports\_end](#input\_fe\_ftp\_int\_passive\_ports\_end) | The ending port that will define the range of ports used for FTP passive mode on the Internal FTP server | `number` | `60420` | no |
| <a name="input_fe_ftp_int_passive_ports_start"></a> [fe\_ftp\_int\_passive\_ports\_start](#input\_fe\_ftp\_int\_passive\_ports\_start) | The starting port that will define the range of ports used for FTP passive mode on the Internal FTP server | `number` | `60401` | no |
| <a name="input_fe_ftp_root_dir"></a> [fe\_ftp\_root\_dir](#input\_fe\_ftp\_root\_dir) | Path for the FTP server's root directory | `string` | `"/mnt/nfs/chd/"` | no |
| <a name="input_fe_health_check_path"></a> [fe\_health\_check\_path](#input\_fe\_health\_check\_path) | Target group health check path | `string` | `"/"` | no |
| <a name="input_fe_instance_size"></a> [fe\_instance\_size](#input\_fe\_instance\_size) | EC2 instance size required for FE instances | `string` | n/a | yes |
| <a name="input_fe_online_mount_path"></a> [fe\_online\_mount\_path](#input\_fe\_online\_mount\_path) | Path to the online NFS mount | `string` | `"/mnt/nfs/chd/online"` | no |
| <a name="input_fe_public_access_cidrs"></a> [fe\_public\_access\_cidrs](#input\_fe\_public\_access\_cidrs) | List of CIDR blocks requiring public access | `list(string)` | `[]` | no |
| <a name="input_fe_service_port"></a> [fe\_service\_port](#input\_fe\_service\_port) | Target group backend port | `number` | `80` | no |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_nfs_finance_mounts"></a> [nfs\_finance\_mounts](#input\_nfs\_finance\_mounts) | A map of objects which contains mount details for each mount path required. | `map(any)` | <pre>{<br/>  "SH_NFSTest": {<br/>    "local_mount_point": "folder",<br/>    "mount_options": [<br/>      "rw",<br/>      "wsize=8192"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nfs_finance_server"></a> [nfs\_finance\_server](#input\_nfs\_finance\_server) | The name or IP of the environment specific NFS server | `string` | `null` | no |
| <a name="input_nfs_mount_destination_parent_dir"></a> [nfs\_mount\_destination\_parent\_dir](#input\_nfs\_mount\_destination\_parent\_dir) | The parent folder that all NFS shares should be mounted inside on the EC2 instance | `string` | `"/mnt"` | no |
| <a name="input_nfs_mounts"></a> [nfs\_mounts](#input\_nfs\_mounts) | A map of objects which contains mount details for each mount path required. | `map(any)` | <pre>{<br/>  "SH_NFSTest": {<br/>    "local_mount_point": "folder",<br/>    "mount_options": [<br/>      "rw",<br/>      "wsize=8192"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nfs_server"></a> [nfs\_server](#input\_nfs\_server) | The name or IP of the environment specific NFS server | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_test_access_enable"></a> [test\_access\_enable](#input\_test\_access\_enable) | Controls whether access from the Test subnets is required (true) or not (false) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chd_bep_address_internal"></a> [chd\_bep\_address\_internal](#output\_chd\_bep\_address\_internal) | n/a |
| <a name="output_chd_frontend_address_internal"></a> [chd\_frontend\_address\_internal](#output\_chd\_frontend\_address\_internal) | n/a |
<!-- END_TF_DOCS -->