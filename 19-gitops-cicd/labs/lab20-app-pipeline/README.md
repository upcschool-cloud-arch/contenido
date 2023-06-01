# GitHub Actions app pipeline

This laboratory will help you to deploy a relatively complex application (PetClinic)
using GitHub actions. In general, it follows best practices with two exceptions:

1. It doesn't contain the source code of the application, as we want to track the
current version of it that is stored in the [Sprint PetClinic repo](github.com/spring-projects/spring-petclinic).
1. It doesn't use [IAM Roles for GitHub Actions](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/),
as we don't have enough permissions to configure them in the AWS Academy.

Apart from it, we can consider this example a good starting point for defining
your own build pipelines.

## Preparation

* Install the [GitHub CLI](https://cli.github.com/), as we will use it to automate the management
of the repo

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

* Create the local repository of the project that will configure the pipeline (usually, the
repo would contain the source code of the application and the infrastructure)

```bash
mkdir github-actions-demo
cd github-actions-demo
git config --global init.defaultBranch main
git init
git config user.name $USER
git config user.email $USER@random.org
```

## Pipeline definition

* Create the well-known directory in which we will put the pipeline definition

```bash
mkdir -p .github/workflows 
```

* Create the pipeline, and take a few minutes to analyze each one of its steps

```yaml
cat << 'EOF' > .github/workflows/petclinic.yaml
name: PetClinic App CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]


jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    
      - name: Checkout
        uses: actions/checkout@v3
        with:
          repository: 'spring-projects/spring-petclinic'

      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: maven

      - name: Test and build with Maven
        run: ./mvnw --batch-mode --update-snapshots package

      - name: aggregate artifacts
        run: mkdir artifacts && cp target/spring-petclinic*.jar* artifacts/

      - name: Publish to packages
        uses: actions/upload-artifact@v3
        with:
          name: spring-petclinic-artifacts
          path: target/spring-petclinic*.jar*

      - name: Install AWS CLI
        uses: unfor19/install-aws-cli-action@master

      - name: Publish to S3
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_SESSION_TOKEN : ${{ secrets.AWS_SESSION_TOKEN }}
          AWS_DEFAULT_REGION: "us-east-1"
        run:  aws s3 cp target/*.jar s3://${{ vars.AWS_BUCKET }}/
EOF
```

* Add and commit the file

```bash
git add -A
git commit -m "Initial commit of the pipeline."
```

## GitHub repository creation

* Authenticate yourself on GitHub using the CLI (follow the instructions provided by the tool)

```bash
gh auth login
```

* Create the new repo, setting it as the *origin* of the local one

```bash
gh repo create github-actions-demo --add-readme --public --source .
```

* Set your AWS credentials (**replace the portion of text in the diamon with the actual values**)

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
export AWS_SESSION_TOKEN=<session_token>
```

* Check that you configured your credentials correctly

```bash
aws sts get-caller-identity
```

* We are going to use an S3 bucket as the artifact repository, so let's create it

```bash
BUCKET_NAME=demo-artifacts-$RANDOM
echo The artifact repository will be $BUCKET_NAME
aws s3 mb s3://$BUCKET_NAME
```

* Retreive your GitHub username

```bash
GH_USER=$(gh api user | jq -r '.login')
echo You are $GH_USER.
```

* Define three secrets for your recently created repository and set your AWS credentials
as their values

```bash
gh secret set AWS_ACCESS_KEY_ID \
  --app actions \
  --body $AWS_ACCESS_KEY_ID \
  --repo $GH_USER/github-actions-demo

gh secret set AWS_SECRET_ACCESS_KEY \
  --app actions \
  --body $AWS_SECRET_ACCESS_KEY  \
  --repo $GH_USER/github-actions-demo

gh secret set AWS_SESSION_TOKEN \
  --app actions \
  --body $AWS_SESSION_TOKEN  \
  --repo $GH_USER/github-actions-demo
```

* We don't consider the name of the bucket as a sensible information, so we set it as
a repository variable instead

```bash
gh variable set AWS_BUCKET --body $BUCKET_NAME --repo $GH_USER/github-actions-demo
```

* Push to the remote repository to launch the pipeline

```bash
git push origin main
```

* Check the GitHub website to watch the progression of the job. Explore the user interface,
including the presentation of the pipeline and the execution log

```bash
echo Open https://github.com/${GH_USER}/github-actions-demo/actions
```

* Once the job is finished, the artifacts should be available under the build log. Download
them to see a possible alterantive to use S3

* Open the bucket on the AWS console and check that the main artifact is there

```bash
echo Open https://s3.console.aws.amazon.com/s3/buckets/$BUCKET_NAME
```

## Challenge: additional jobs for documentation

The [previous lab](../lab10-app-exploration/README.md) provides many more actions available
to you for increasing the quality of the pipeline, by adding additional phases (like doc generation)
or different reports (tests results, code coverage, etc...).

Add an additional [Job](https://docs.github.com/en/actions/using-jobs) for generating the documentation.
All jobs are executed by default in parallel, so avoiding adding documentation generation in the build
step can improve the overall performance of the pipeline.

## Challenge: additional steps for the build job

Also, it is very useful to transform the results of the tests, the code coverage, etc into
artifacts and publish them for easy usage. Add new steps to the build job for
uploading the result of the tests, executing the *jacoco* code coverage tool and
uploading the generated report, etc.

## Cleanup

* Authorize the GitHub CLI to delete repositories (follow the instructions on screen)

```bash
gh auth refresh -h github.com -s delete_repo
```

* Remove the repo

```bash
gh repo delete github-actions-demo
```
