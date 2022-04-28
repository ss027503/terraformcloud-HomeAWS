locals {
    project_name = "module-test"
    something = "here2"
}

module gen_secret {
    source = "git@ss027503.github.com:ss027503/terraform-modules.git//aws/gen-secret"

    secret_name = "some-test-secret"
    length = 18
    special = false
}