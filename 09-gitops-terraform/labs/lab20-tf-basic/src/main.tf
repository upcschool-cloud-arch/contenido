resource "random_pet" "random_value" {
}

locals {
  generated_value = "${var.prefix}-${random_pet.random_value.id}"
}
