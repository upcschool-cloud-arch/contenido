# Backends

Storing Terraform state in a local directory is unacceptable, as it is prone to be corrupted by accident and
cannot be shared in a reliable way.

## Exercise

The directory [./00-src-init-backend](./00-src-init-backend) creates an S3 bucket for storing the state
and a DynamoDB table to avoid simultaneous manipulation of the infrastructure from two different runners.

* `validate`, `init` and `apply` the configuration stored in [00-src-init-backend](./00-src-init-backend),
and take note of the output.

## Exercise

[10-src-network](./10-src-network/) contains our familiar basic network infrastructure.

* `validate`, `init` and `apply` it, to initialize a **local** backend.

* Update the [10-src-network/providers.tf](./10-src-network/providers.tf) file, uncommenting and fixing
the *backend* configuration portion so it points to the resources initialized in the previous exercise.

* `init` the configuration again, to see how the state is migrated to the S3 bucket.

* Check the bucket in the web console, or using the command line tool.

* Delete the local state (`*tfstate*` files).

* Use `terraform output` to check how the state is still safely stored in S3