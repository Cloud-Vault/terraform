locals {
    open-api = {
        500 = {
            description = "500 Internal Server Error"
            headers = {
                Access-Control-Allow-Origin = {
                    schema = {
                        type = "string"
                    }
                }

                Access-Control-Allow-Methods = {
                    schema = {
                        type = "string"
                    }
                }

                Access-Control-Allow-Headers = {
                    schema = {
                        type = "string"
                    }
                }
            }

            content = {
                "application/json" = {
                    schema = {
                        "$ref" = "#/components/schemas/Error"
                    }
                }
            }
        }
    } : lookup(configuration, "responses", {})
    }
}
