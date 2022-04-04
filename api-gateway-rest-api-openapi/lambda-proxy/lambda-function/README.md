[//]: # (<!-- BEGIN_TF_DOCS -->)



# `rest-api-gateway-v4` - *Terraform* #

*Infrastructure as Code*

## Table of Contents ##

[[_TOC_]]

---

## Overview ##

[//]: # ([User-Input] | configuration/documentation/overview.md)

Terraform Project Overview & Information

***Please Note*** - the following documentation is assumed to be rendered via
`GitLab Flavored Markdown`, and consequently may be incorrectly displayed via
certain IDEs or web-browser-specific implementations.

### First Time Setup ###

<details>
<summary>Select Dropdown to View Instructions</summary>

Every step in the listed section is of drastic importance, and failure to follow
explicit instructions can and likely will result in a full system, service-specific outage.

1. Navigate into the `[Project]/configuration/documentation` folder.
2. Update `metadata.md` with the following change(s):
    1. [Front-Matter](https://docs.gitlab.com/ee/user/markdown.html#front-matter) Metadata Section
        1. ID (GitLab Repository Project-ID)
        2. Project (GitLab Repository URL)
        3. Pipeline-URL (GitLab Repository's Pipeline URL)
        4. GitHub-Source (If Applicable - Pipeline's Deployment Repository)
        5. GitHub-Default-Branch (If Applicable - Pipeline's Deployment Repository)
3. Determine appropriate variables found in `[Project]/variables.tf`:
    1. `service` - Common-Name or Deployable Alias
        1. Example) `Login` (A Front-End Login Page, SPA)
    2. `subdomain` - Front-End Target Subdomain
        1. Example) `user-login`
4. Establish global variable(s) located in `[Project]/.gitlab-ci.yml`:
    1. `REPOSITORY` - ***Repository Name***, the last folder-path found in `header.md`'s `GitHub-Source` assignment.
        1. Example) If the repository is `https://github.com/organization-name/repository-1.git`, `REPOSITORY` = `repository-1`
5. Generate the `terraform.tfvars` & `terraform.tfvars.json` Files.
   ```bash
   chmod a+x "$(git rev-parse --show-toplevel)/ci-cd/tfvars"
   eval "$(git rev-parse --show-toplevel)/ci-cd/tfvars"
   ```
6. Generate the project's documentation - `README.md`.
   ```bash
   chmod a+x "$(git rev-parse --show-toplevel)/ci-cd/inject"
   eval "$(git rev-parse --show-toplevel)/ci-cd/inject"
   ```
7. Remove any previous `.gitlab-*` files.
   ```bash
   rm -rf $(git rev-parse --show-toplevel)/ci-cd/.gitlab-*
   ```
8. [Create a Personal Access Token](https://gitlab.mycapstone.com/-/profile/personal_access_tokens)
   with API permissions, if one hasn't already been created for `terraform` related usage.
9. Update `terraform.tfvars` with an `environment` and `certificate` value.
    - It's strongly recommended to first start with `Development` environment-related configuration(s).
10. Initialize Terraform State.
    ```bash
    chmod a+x "$(git rev-parse --show-toplevel)/ci-cd/initialize-state"
    eval "$(git rev-parse --show-toplevel)/ci-cd/initialize-state"
    ```
    - Note that section 2's `metadata.md` can and should be used as reference.
    - For `Username`, this will be a GitLab user's username.
    - The prompt `Gitlab Hostname` is the server-related hostname where self-hosted GitLab instance resides.
        - `gitlab.mycapstone.com`
    - If any prompts relating to existing state are prompted, ***read them carefully***.

</details>

## IaC ##

### Setup & Runtime ###

The following package(s) & Terraform provider(s) are required
in order to manage the following infrastructure.

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.8 |

The following executables are required to be installed
for local development:

- `terraform`
- `terraform-docs`

However, installation of these applications is beyond the document's context.

## Package ##

### Pipeline & Local Input ###

The following variables are required for an autonomous deployment.

##### Example Input File(s) #####

***`terraform.tfvars.json`*** - **Note**: `null` value(s) *may be required* to be populated via the user or the ci-cd runtime.

```json
{
  "account": null,
  "artifacts-bucket": null,
  "description": null,
  "environment-variables": {
    "NODE_ENV": "production"
  },
  "execution-source": null,
  "iam-role": null,
  "memory-size": null,
  "name": null,
  "publish": null,
  "runtime": null,
  "timeout": null,
  "vpc-configuration": null
}
```

***`terraform.tfvars`*** - **Note**: empty string(s) are required to be populated via the user, or the ci-cd runtime.

<details>
<summary>HCL Configuration Language Input File</summary>

```hcl
account          = ""
artifacts-bucket = ""
description      = ""
environment-variables = {
  "NODE_ENV": "production"
}
execution-source  = ""
iam-role          = ""
memory-size       = ""
name              = ""
publish           = ""
runtime           = ""
timeout           = ""
vpc-configuration = ""
```

</details>

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | API Gateway Execute-API Source AWS Account for Lambda-Permission Resource(s) | `string` | n/a | yes |
| <a name="input_artifacts-bucket"></a> [artifacts-bucket](#input\_artifacts-bucket) | AWS Lambda Function Artifacts S3 Bucket | `string` | n/a | yes |
| <a name="input_execution-source"></a> [execution-source](#input\_execution-source) | API Gateway Execute-API Invocation Source ARN for Lambda-Permission Resource(s) | `string` | n/a | yes |
| <a name="input_iam-role"></a> [iam-role](#input\_iam-role) | Lambda Function IAM Role (ARN) Reference | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Resource Endpoint Partition for Invocation of Lambda Function from API Gateway | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Lambda Function Description | `string` | `null` | no |
| <a name="input_environment-variables"></a> [environment-variables](#input\_environment-variables) | Runtime Environment Configuration | `map(string)` | <pre>{<br>  "NODE_ENV": "production"<br>}</pre> | no |
| <a name="input_memory-size"></a> [memory-size](#input\_memory-size) | Runtime Memory Allocation (MB) - Defaults to 256 | `number` | `null` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Enable Lambda Version Publishing | `bool` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime Language + Version | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Runtime Timeout (Seconds) - Defaults to 30 Seconds | `number` | `null` | no |
| <a name="input_vpc-configuration"></a> [vpc-configuration](#input\_vpc-configuration) | Lambda Function VPC Connection Integration(s) | <pre>object({<br>        security-group-identifiers = set(string)<br>        subnet-identifiers         = set(string)<br>    })</pre> | `null` | no |

Additionally, please note that **only the `terraform.tfvars` file is automatically searched for**; if `terraform.tfvars.json`
-- or any arbitrary `*.json` file -- is instead the target input file, then the `--var-file` flag needs to be
included.

With the required variables defined via `terraform.tfvars`, execute a `terraform`
related command(s) via:

```bash
terraform validate
terraform plan --out "local-state"
terraform apply --state "local-state" --state-out "local-state.archive"
```

or via a `terraform.tfvars.json` (or another type of `*.json` file) ...

```bash
terraform validate --json
terraform plan --out "local-state" --var-file "terraform.tfvars.json"
terraform apply --state "local-state" --state-out "local-state.archive" --var-file "terraform.tfvars.json"
```

---

#### Resources

| Name | Type |
|------|------|
| [aws_lambda_function.function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.lambda-invocation-permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_object.artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [archive_file.lambda-function-artifact](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

#### Modules

No modules.

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact"></a> [artifact](#output\_artifact) | n/a |
| <a name="output_artifact-bucket"></a> [artifact-bucket](#output\_artifact-bucket) | n/a |
| <a name="output_artifact-bucket-object-key"></a> [artifact-bucket-object-key](#output\_artifact-bucket-object-key) | n/a |
| <a name="output_artifact-bucket-source"></a> [artifact-bucket-source](#output\_artifact-bucket-source) | n/a |
| <a name="output_invocation-lambda-permission"></a> [invocation-lambda-permission](#output\_invocation-lambda-permission) | n/a |
| <a name="output_module"></a> [module](#output\_module) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_source-code-hash"></a> [source-code-hash](#output\_source-code-hash) | n/a |
| <a name="output_version"></a> [version](#output\_version) | n/a |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.8 |

---

[//]: # ([Static] | configuration/documentation/footer.md)

## Auto-Generating Documentation ##

In order to successfully generate `terraform` documentation, the following steps need to be
performed in order:

1. `eval "${PWD}/ci-cd/initialize-state` - Initialize Terraform
2. `eval "${PWD}/ci-cd/tfvars"` - Generate the `terraform.tfvars` & `terraform.tfvars.json` Files
3. `eval "${PWD}/ci-cd/inject"` - Inject `README.md` via Configuration Settings + `*.md` Files

Lastly, Commit & Push to VCS.

### Errors during Render ###

- Ensure `terraform-docs` is correctly installed and updated to the latest version.
- Check the version of `terraform`, and ensure it's caught up to the latest version.
- Read the error message in its entirety, and search for contextual keywords online.


[//]: # (<!-- END_TF_DOCS -->)