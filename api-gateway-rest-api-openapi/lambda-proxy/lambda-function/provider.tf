terraform {
    experiments = [
        module_variable_optional_attrs
    ]

    required_providers {
        aws = "~> 4.8"
    }
}
