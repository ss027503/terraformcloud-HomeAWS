locals {
    project_name = "module-test"
    something = "here"
}

module gen_secret {
    source = "git@github.com:ss027503/terraform-modules/aws/gen-secret.git"

    secret_name = "some-test-secret"
    length = 18
    special = false
}