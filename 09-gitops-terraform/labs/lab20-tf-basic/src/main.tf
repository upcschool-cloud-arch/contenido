resource "random_pet" "random_plain" {
}

resource "random_pet" "random_sensitive" {
}

locals {
  generated_plain = "${var.prefix}-${random_pet.random_plain.id}"
  generated_sensitive = sensitive("${var.prefix}-${random_pet.random_sensitive.id}")
}
