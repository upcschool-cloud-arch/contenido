# AWS CLI configuration

## Objective

This laboratory is designed to provide hands-on experience with the AWS CLI tool. The main objective is to understand how to configure and manage AWS CLI access permissions.
Procedure

* The trainer will provide each team with a unique URL that directs to a terminal. Each team will also receive a unique login.
* Teams should familiarize themselves with the AWS documentation, particularly focusing on how to provide the required information (access key, user key, session token) in the AWS CLI configuration file (~/.aws/credentials).
* After configuring the AWS CLI, teams should verify their setup by running the aws sts get-caller-identity command. This command returns details about the IAM user or role whose credentials are used to call the operation.
* Once verified, teams should then remove the configuration file.
* Finally, teams will reconfigure the AWS CLI access, but this time using environment variables to provide the same credentials.

## Expected Outcome

By the end of this lab, teams should be able to:

* Understand how to provide AWS CLI with the necessary access credentials
* Verify the identity of the caller using the AWS Security Token Service (STS).
* Understand how to use environment variables to configure AWS CLI access.

## Tips

* [Environment variables to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
* [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* `aws sts get-caller-identity` [command reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-caller-identity.html)
