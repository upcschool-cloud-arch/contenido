# Terraform introduction

This lab provides the very essential terraform configuration using
[HCL](https://developer.hashicorp.com/terraform/language). It includes:

* A [providers.tf](src/providers.tf) file to declare what collection
of resources are we going to manipulate. In this case, random expressions.
* A [variables.tf](src/variables.tf) file with a single variable, which
acts as the input parameters of the program.
* A [main.tf](src/main.tf) file with both a
[random pet resource](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) and a [local](https://developer.hashicorp.com/terraform/language/values/locals) value that works as an actual local
variable.
* A [outputs.tf](src/outputs.tf)