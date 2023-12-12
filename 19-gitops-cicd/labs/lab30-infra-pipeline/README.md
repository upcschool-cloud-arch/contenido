# Github actions Terraform

This laboratory will help you to deploy infraestructure components using Terraform and Github actions to automate the deployment of changes, using the Git repository as unique source of truth.

## Preparation

* Install the [GitHub CLI](https://cli.github.com/), as we will use it to automate the management
of the repo

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh jq -y
```

## Backend configuration

Following GitOps best practises, we will initialize a Terraform remote backend, instead of tracking the state file in the git repository.

1.1- Use the Terraform files from [Lab50 Module 09-gitops-terraform](../../../09-gitops-terraform/labs/lab50-backends/00-src-init-backend/) to create an S3 bucket for storing the state
and a DynamoDB table to avoid simultaneous manipulation of the infrastructure from two different runners.

1.2- `validate`, `init` and `apply` the configuration stored in [00-src-init-backend](../../../09-gitops-terraform/labs/lab50-backends/00-src-init-backend/),
and **take note of the output**.

1.3- Make sure the S3 Bucket and DynamoDB table have been created correctly


## Local Repository initialization

2.1- Create the local repository of the project that will configure the pipeline

```bash
mkdir poc-actions-terraform
cd poc-actions-terraform
git config --global init.defaultBranch main
git init
```

2.4- Add the following `.gitignore` to avoid uploading undesired files to GitHub

```.gitignore
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Configuration files
*.conf
```

2.5- Copy the source code you will find in [./00-src-network/](./00-src-network/) and take the opportinity to look at the code. Finally, commit.

```bash
git add --all
git commit -m "first commit"
```

## Github Repository initialization

3.1- Next, we will **create a new repository in GitHub** where we will push the source code.

3.2- Authenticate yourself on GitHub using the CLI (follow the instructions provided by the tool)

```bash
gh auth login
```

3.3- Create the new repo, setting it as the *origin* of the local one

```bash
gh repo create poc-actions-terraform --public --source .
```

## Local Terraform Run

3.1- Set your AWS credentials (**replace the portion of text in the diamon with the actual values**)

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
export AWS_SESSION_TOKEN=<session_token>
```

3.2- Check that you configured your credentials correctly

```bash
aws sts get-caller-identity
```

3.3- Try to run `terraform init` locally. The command should prompt you for the mandatory variables necessary to initialize the backend. This is because the backend definition in `providers.tf`, is empty!
This time, we are providing a configuration file with the backend configuration `backend.conf`

```bash
cat << EOF > backend.conf
bucket = "--- your bucket name ---"
key    = "terraform.tfstate"
dynamodb_table = "--- your DynamoDB table --"
region = "us-east-1"
EOF
```

```bash
$ terraform init -backend-config=backend.conf
```

3.4- Make sure the source code is correct using `terraform validate`


## Configure GitHub Actions

4.1- Retreive your GitHub Username

```bash
GH_USER=$(gh api user | jq -r '.login')
echo You are $GH_USER.
```

4.2- Define three secrets for your recently created repository and set your AWS credentials
as their values

```bash
gh secret set AWS_ACCESS_KEY_ID \
  --app actions \
  --body $AWS_ACCESS_KEY_ID \
  --repo $GH_USER/poc-actions-terraform

gh secret set AWS_SECRET_ACCESS_KEY \
  --app actions \
  --body $AWS_SECRET_ACCESS_KEY  \
  --repo $GH_USER/poc-actions-terraform

gh secret set AWS_SESSION_TOKEN \
  --app actions \
  --body $AWS_SESSION_TOKEN  \
  --repo $GH_USER/poc-actions-terraform
```

4.3- We don't consider the Terraform Backend configuration of the bucket as sensible information, so we set the `s3 bucket name` together with the `dynamodb table name` as a repository variable instead.

```bash
gh variable set s3_bucket --body "<S3 BUCKET NAME>" --repo $GH_USER/poc-actions-terraform
gh variable set dynamodb_table --body "<DYNAMODB TABLE>" --repo $GH_USER/poc-actions-terraform
```

4.4- Use the Github UI to check that the secrets together with the variable are set correctly.

```bash
echo "Visit https://github.com/$GH_USER/poc-actions-terraform/settings/secrets/actions"
```

Notice that secrets can not be visualized, thus can only be updated or deleted


# Configure the base workflow

```yml
name: Github Actions Terraform
on: [push]
jobs:
  format_check:
    name: Terraform Validation Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Extract Backend Config
        run: |
          cat << EOF > backend.conf
            bucket = "${S3_BUCKET}"
            key    = "terraform.tfstate"
            dynamodb_table = "${DYNAMODB_TABLE}"
            region = "us-east-1"
          EOF
        env:
          S3_BUCKET: ${{ vars.s3_bucket }}
          DYNAMODB_TABLE:  ${{ vars.dynamodb_table }}

      - uses: hashicorp/setup-terraform@v3

      - name: Terraform fmt
        run: terraform fmt -check
        continue-on-error: true

      - name: Terraform Init
        run: terraform init -backend-config=backend.conf
        env:
          AWS_ACCESS_KEY_ID:  ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY:  ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_SESSION_TOKEN:  ${{ secrets.AWS_SESSION_TOKEN }}

      - name: Terraform Validate
        run: terraform validate -no-color
```






//Then plan (master)

//Then apply when release

//Notice the backend information is empty.... We will provide this information as an env variable




