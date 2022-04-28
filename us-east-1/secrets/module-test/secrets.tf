locals {
    project_name = "module-test"
    something = "here2"
}

module gen_secret {
    source = "git::https://github.com:ss027503/terraform-modules.git//aws/gen-secret?ref=main"

    secret_name = "some-test-secret"
    length = 18
    special = false
}