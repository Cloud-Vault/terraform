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
