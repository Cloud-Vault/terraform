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