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
terraform f██ -write=false *.tf
```

* See what changes should be required to make it compliant

```bash
terraform f██ -diff -write=false *.tf
```

* Do effective the changes

```bash
terraform f██ *.tf
```

## Dependency downloading

* Initialize the required provider

```bash
terraform init
```

* What is the purpose of the file `.terraform.lock.hcl`? (hint: it is explained in the output of the `init` command)

* Validate the syntax of the project

```bash
terraform va██████
```

## Planning changes

* Get the report with the expected actions to be taking when the project is applied

```bash
terraform pl██ -var prefix=demo
```

* What are the names of the properties with default values (and because of that, not appearing explicitly in the configuration)
of the resource `random_pet.random_value`?


## Applying the configuration

* Execute the configuration update with

```bash
terraform apply -var prefix=demo -auto-approve
```

* How many resources where added, changed or destroyed?

* Check the content of the generated state

```bash
cat terraform.tfstate | jq -C | less -R
```

* Get the value of the outputs using the `terraform` command

```bash
terraform out███
```

* Read the value of a particular output, and save it into a variable

```bash
VAL=$(terraform out███ -raw my_random_value)
echo $VAL
```

## Functions

Let's say that the value hold by `local.generated_value` can be considered *sensitive*. We will update
the script and apply the new configuration.

* Check the [function docs](https://developer.hashicorp.com/terraform/language/functions/sensitive) and
covert the `local` value into a sensitive string

```bash
sed -i '5s/.*/  generated_value = "${var.prefix}-${█████████(random_pet.random_value.id)}"/' main.tf
cat main.tf
```

* Try to apply the changes again (**it will fail**)

```bash
terraform apply -var prefix=demo -auto-approve
```

* Carefully read the error message, and use it to correct the output value

```bash
sed -i '3 a\  █████████=true' outputs.tf
```

* Apply the desired state again, this time it will work as expected

```bash
terraform apply -var prefix=demo -auto-approve
```

* As the sensitive condition is just metainformation and it only affects the outputs,
no actual resource update has ocurred. What does it means, regarding the *state* file content?

```bash
terraform output -raw my_random_value; echo
cat terraform.tfstate | jq .outputs.my_random_value
```

## Variable files

We want to set an easy way to provide default values that can be tracked by `git`. Read the
[variables definition file](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
explanation to understand what it is expected.

* Create a `terraform.tfvars` file

```bash
echo prefix = \"demo\" > terraform.tfv███
cat terraform.tfv███; echo
```

* Check how it is possible to apply the configuration without explicitly providing the value for the `prefix` variable

```bash
terraform apply -auto-approve
```

## Clean up

* Delete all resources referenced by the state file. **Carefully read the output of the command**, understanding
the consequences of proceeding

```bash
terraform apply -dest███
```

## Provider demystification

A *provider* is just an executable file implementing a [gRPC](https://grpc.io/) server. It is possible to keep it
running in the background and attach a particular `terraform` command against it, enabling us to track the execution
of the different commands.

* Find the executable file

```bash
PROV=$(find . -name "*provider-random*")
echo The random provider executable is $PROV.
```

* Execute it (it will fail, but providing an useful message)

```bash
eval $PROV
eval $PROV -h
```

* Start the debug mode of the plugin in another `tmux` pane

```bash
tmux split-window $PROV -debug; tmux last-pane
```

* Follow the instructions provided by the output of the command and export the variable

```bash
TF_REATTACH_PROVIDERS='{"registry.terraform.io/hashic... COPY THE VALUE FROM THE OUTPUT}'
export TF_REATTACH_PROVIDERS
```

* Apply again the configuration and see how the provider is doing its work

```bash
terraform apply -var prefix=demo -auto-approve
```

* Take any line from the output of the provider and format it to understand the performed action. It will
show you something like this:

```json
{
  "@caller": "github.com/hashicorp/terraform-plugin-framework@v1.2.0/internal/fwserver/server_applyresourcechange.go:42",
  "@level": "trace",
  "@message": "ApplyResourceChange received no PriorState, running CreateResource",
  "@module": "sdk.framework",
  "@timestamp": "2023-04-15T20:38:19.775248+01:00",
  "tf_provider_addr": "registry.terraform.io/hashicorp/random",
  "tf_req_id": "98b57646-ee61-b557-f7f0-b7d8b94d90e6",
  "tf_resource_type": "random_pet",
  "tf_rpc": "ApplyResourceChange"
}
```

* Stop the provider and remove the variable

```bash
kill -15 $(pidof $PROV)
unset TF_REATTACH_PROVIDERS
```