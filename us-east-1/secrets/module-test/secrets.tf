locals {
    project_name = "module-test"
    something = "here3"
}

module gen_secret {
    source = "git::https://github.com:ss027503/terraform-modules/aws/gen-secret"

    secret_name = "some-test-secret"
    length = 18
    special = false
}
