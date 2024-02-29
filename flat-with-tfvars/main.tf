variable "foo" {
}

resource null_resource "always"{
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo ${var.foo}"
  }
}