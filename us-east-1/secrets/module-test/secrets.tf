module gen_secret {
    source = "https://github.com/ss027503/terraform-modules/aws/gen-secret"

    secret_name = "some-test-secret"
    length = 18
    special = false
}