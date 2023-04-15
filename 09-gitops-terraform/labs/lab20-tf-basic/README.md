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
* A [outputs.tf](src/outputs.tf) that will provide useful information once the configuration is applied.

## Preliminary work

* Ensure you are in the `src` folder

```bash
cd src
pwd
```

* Check the HCL files to see if all of them are correctly formatted (can you tell which file is the offender one?)

```bash
terraform fmt -write=false *.tf
```

* See what changes should be required to make it compliant

```bash
terraform fmt -diff -write=false *.tf
```

* Do effective the changes

```bash
terraform fmt *.tf
```

