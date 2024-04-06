# Advanced IAM Workshop

*This is a 400 level workshop. It is not intended to be done until you feel familiar with the basic IAM constructs.*

*This workshop cannot be complited with the accounts provided by AWS Academy, as it requires full permission for managing IAM resources.
On the other hand, the cost of the workshop should be almost 0. Feel free to create to accounts to run it, and delete those accounts after
completing the steps.*

This workshop intents to clarify how IAM Roles work to provide cross account access. In practical scenarios, thanks to the Identity Center service, it is not necessary to go through all this work just to implement global access policies across an organization. But going deep into the details helps to put light on aspects of the underlaying mechanisms.

Part of the workshop is redacted (with ▒▒▒▒ characters instead of the corresponding text). This is a way to force you to investigate the correct syntax, use your google-fu to achieve the goal ;)

Please, **read each section before trying to complete it**. This way you will have a better understanding of the what is the expected result.

## Scenario

We will use two different accounts for this workshop: one intended to represent the development account and other one for production.

You will also impersonate five different persons:

* Alice, the global administrator and responsible of the management for most of the IAM resources.
* Bob and Charlie, our beloved developers. They just want to write code, test it in the development account, and publish the executable artifacts in a bucket in the production account.
* Daniella, responsible for operations and deployments. She is the one who will create the bucket in the production account. Also, she can create a Role for allowing the developers to make use of that bucket.
* Emmet, an auditor: will need to access in read-only mode both the dev and the prod account.

Also, you will need to provide proper permissions to one application, linking a role to its server.

## Preparation


* Choose a prefix to avoid collision between identifiers. It must be in lowercase to avoid naming rules problems(for example: S3 only allow lowercase)

```bash
export PREFIX=<your very own prefix, like "teamX">
```

* Set variables with the IDs of both accounts (you find them in the SSO page)

```bash
export DEV_ACCOUNT=<your first account>
export PROD_ACCOUNT=<your second account>
```

* Create the `.aws` directory, where different credential files are going to be placed

```bash
mkdir ~/.aws
```

## Global admin workflow 1: initial development accounts setup

During all this section you will work as Alice, the global administrator. She will create all the required IAM resources.

* Set the permissions to access the `DEV_ACCOUNT` (you can get them from the SSO console, through `programmatic access`)

```bash
export AWS_ACCESS_KEY_ID="ASIAZXMR..."
export AWS_SECRET_ACCESS_KEY="nFOpOJip..."
export AWS_SESSION_TOKEN="IQoJb3JpZ..."
```

* Check your account ID

```bash
echo Active account: $(aws sts get-caller-identity --query Account --output text). Should be $DEV_ACCOUNT.
```

* Create users for our developers on that account

```bash
aws iam create-▒▒▒▒ --user-name ${PREFIX}-Bob
aws iam create-▒▒▒▒ --user-name ${PREFIX}-Charlie
```

* Create a group for those developers

```bash
aws iam create-group --group-name ${PREFIX}-developers
aws iam list-groups --output table
```

* Add the users to the group

```bash
aws iam add-user-to-group --▒▒▒▒▒-name ${PREFIX}-developers --▒▒▒▒-name ${PREFIX}-Bob
aws iam add-user-to-group --▒▒▒▒▒-name ${PREFIX}-developers --▒▒▒▒-name ${PREFIX}-Charlie
```

* Check everything is in place

```bash
aws iam get-group --group-name  ${PREFIX}-developers --output text
```

* Generate Access Keys and Secret Keys to both users. We will save them in files for later usage.

```bash
aws iam create-access-key --user-name $PREFIX-Bob | tee bob.json
aws iam create-access-key --user-name $PREFIX-Charlie | tee charlie.json

ls

cat bob.json
cat charlie.json
```

## Global admin workflow 2: providing authorization to the developers on their account

* Get the identifier of the S3 full access policy

```bash
S3_FULL_ACCESS_POLICY=$(aws iam list-policies --query 'Policies[?PolicyName==`AmazonS3FullAccess`].Arn' --output text)
echo The ARN of the S3 full access policy is $S3_FULL_ACCESS_POLICY.
```

* Allow developers to fully take control of S3 on their accounts (remember, we are running this commands with Alice creds on `DEV_ACCOUNT`)

```bash
aws iam ▒▒▒▒▒▒-group-policy --group-name  ${PREFIX}-developers --policy-arn $S3_FULL_ACCESS_POLICY
```

## Global admin workflow 3: initial production account setup

* Set the credentials for accessing the second account (the `PRODUCTION` one)

```bash
export AWS_ACCESS_KEY_ID="ASIAZUIUYR..."
export AWS_SECRET_ACCESS_KEY="nFOp2342314p..."
export AWS_SESSION_TOKEN="IQoJbasdfasfdJpZ..."
```

* Check your new account ID

```bash
echo Active account: $(aws sts get-caller-identity --query Account --output text). Should be $PROD_ACCOUNT.
```

* Repeat the previous steps, but in this case for our systems operator (Daniella)

```bash
aws iam create-▒▒▒▒ --user-name ${PREFIX}-Daniella
aws iam create-group --group-name ${PREFIX}-sysops
aws iam add-user-to-group --▒▒▒▒▒-name ${PREFIX}-sysops --▒▒▒▒-name ${PREFIX}-Daniella

aws iam get-group --group-name  ${PREFIX}-sysops --output text

aws iam create-access-key --user-name $PREFIX-Daniella | tee daniella.json
cat daniella.json
```

* Let's provide full super powers to our operations team in the production account

```bash
ADMIN_POLICY=$(aws iam list-policies --query 'Policies[?PolicyName==`AdministratorAccess`].Arn' --output text)
echo The ARN of the Admin policy is $ADMIN_POLICY.

aws iam ▒▒▒▒▒▒-group-policy --group-name  ${PREFIX}-sysops --policy-arn $ADMIN_POLICY
```

## Developer workflow 1: creating the staging repository of files

Remember: as a developer, Bob has received his credentials from Alice (inside `bob.json`).

* First, remove Alice credentials  (we are not global administrators anymore)

```bash
unset AWS_ACCESS_KEY_ID
```

* You are a developer, so let's write an application server program (we will deploy it later in production)

```bash
cat << EOF > server.sh
#!/bin/sh

echo Starting server now on port 8080

while true;
  do echo -e "HTTP/1.1 200 OK\n\n$(top -b -n 1)" \
  | nc -l -k -p 8080 -q 1;
  echo Request processed.
done
EOF
```

* Define Bob (one of our devs) credentials for his laptop, using the data stored in the `bob.json` file created by Alice

```bash
cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id=$(jq -r .AccessKey.AccessKeyId bob.json)
aws_secret_access_key=$(jq -r .AccessKey.SecretAccessKey bob.json)
EOF
```

* Check that you are actually using Bob's creds

```bash
aws sts get-caller-identity
```

* Bob belongs to the `DEVELOPERS` group, and that group has a permission policy. Let's use it to create a bucket (the developers can do whatever they want with their accounts, but only Daniella can create a bucket in the production account)

```bash
DEV_BUCKET_NAME=$PREFIX-dev-bucket-$RANDOM
echo Your development bucket will be $DEV_BUCKET_NAME

aws s3 ▒▒ s3://$DEV_BUCKET_NAME
```

* Upload (copy) the application to our development repository (the bucket)

```bash
aws s3 ▒▒ ./server.sh s3://$DEV_BUCKET_NAME/

aws s3 ls s3://$DEV_BUCKET_NAME
```

## Sysops workflow 1: creating the production repository of files

Let's impersonate Daniella (ops team leader) and create the production bucket in the production account.

* First, remove Alice credentials  (we are not global administrators any more)

```bash
unset AWS_ACCESS_KEY_ID
```


* Overwrite the permissions file with Daniella's credentials

```bash
cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id=$(jq -r .AccessKey.AccessKeyId daniella.json)
aws_secret_access_key=$(jq -r .AccessKey.SecretAccessKey daniella.json)
EOF
```

* Check that you are actually using Daniella's creds

```bash
aws sts get-caller-identity
```

* Create the production bucket

```bash
PROD_BUCKET_NAME=$PREFIX-prod-bucket-$RANDOM
echo Your production bucket will be $PROD_BUCKET_NAME

aws s3 ▒▒ s3://$PROD_BUCKET_NAME
```

## CLI profiles

Changing from one user to another is becoming a burden for this lab, so let's define 
different profiles to make it easier. A profile is a way to keep different credentials
stored in `.aws/credentials` and applying the desired one for each occasion.

Remember: this is just a convinience trick for
this workshop, **it doesn't make sense to keep a file with credentials belonging to
different persons**.

* Let's start setting again Alice credentials for accessing the **development** account

```bash
export AWS_ACCESS_KEY_ID="ASIAZXMR..."
export AWS_SECRET_ACCESS_KEY="nFOpOJip..."
export AWS_SESSION_TOKEN="IQoJb3JpZ..."
```

* Please, check again if the creds belong to the correct account

```
echo Active account: $(aws sts get-caller-identity --query Account --output text). Should be $DEV_ACCOUNT.
```

* Recreate the `.aws/credentials`

```bash
cat << EOF > ~/.aws/credentials
[alice-dev]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
aws_session_token=$AWS_SESSION_TOKEN

EOF
```

* Now overwrite the environment variables with Alice **production** account credentials

```bash
export AWS_ACCESS_KEY_ID="ASIAZXMR..."
export AWS_SECRET_ACCESS_KEY="nFOpOJip..."
export AWS_SESSION_TOKEN="IQoJb3JpZ..."
```

* Are we sure that we are using production credentials? Let's check it:

```
echo Active account: $(aws sts get-caller-identity --query Account --output text). Should be $PROD_ACCOUNT.
```

* Append those credentials to a different profile the `.aws/credentials` 

```bash
cat << EOF >> ~/.aws/credentials
[alice-prod]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
aws_session_token=$AWS_SESSION_TOKEN

EOF
```

* Now add the credentials of Bob (dev) and Daniella (sysops)

```
cat << EOF >> ~/.aws/credentials
[bob]
aws_access_key_id=$(jq -r .AccessKey.AccessKeyId bob.json)
aws_secret_access_key=$(jq -r .AccessKey.SecretAccessKey bob.json)

[daniella]
aws_access_key_id=$(jq -r .AccessKey.AccessKeyId daniella.json)
aws_secret_access_key=$(jq -r .AccessKey.SecretAccessKey daniella.json)

EOF
```

* Check the content of our credentials file

```bash
cat .aws/credentials
```

* Remove the credentials from the environment variable

```bash
unset AWS_ACCESS_KEY_ID
```

* See how can you assume different credentials easily

```bash
aws sts get-caller-identity --profile alice-dev
aws sts get-caller-identity --profile alice-prod
aws sts get-caller-identity --profile bob
aws sts get-caller-identity --profile daniella
```

## Sysops workflow 2: providing write access to the prod repository

In this section, Daniella (sysops) will receive a call from Bob (dev) to allow him
to publish the application in the production repository. Daniella has full access to 
the production account, so she is going to create a role for the developers.

During this lab, feel free to keep using the web console to better understand what
entities are being created, and what are the relationships between them.

* First, check how Bob fails copying the file to the production bucket

```bash
aws s3 cp ./server.sh s3://$PROD_BUCKET_NAME --profile bob
```

* Daniella needs to create a *trust policy*, the element that allows users from other accounts 
(in this case, the development one) to access de production one:

```bash
cat << EOF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::$DEV_ACCOUNT:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
```

* See the result of the file creation (in particular, the `arn` of the source account). Also, remember
that the `condition` attribute can be used to further limit the users allowed to take advantage of the
role

```bash
echo Remember, dev account is $DEV_ACCOUNT.

cat trust-policy.json
```

* Daniella can now create a role for the dev team, so they can access the production account

```bash
TRUST_POLICY=`cat trust-policy.json |  tr '\n' ' '`

aws iam create-role \
  --role-name $PREFIX-developers-on-production \
  --description "Allow users from the developer account to use the production one." \
  --assume-role-policy-document "$TRUST_POLICY" \
  --output text \
  --query 'Role.Arn' \
  --profile daniella
```

* Now, our sysops will create a *permission policy* to allow write access to the production bucket

```bash
cat << EOF > write-only-prod-bucket-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "WriteObjectsToProductionRepositoryBucket$RANDOM",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": ["arn:aws:s3:::$PROD_BUCKET_NAME/*"]
        }
    ]
}
EOF
```

* Let's attach the policy to the developer role (in the production account)

```bash 
S3_WRITE_PERMISSION_POLICY=`cat write-only-prod-bucket-policy.json |  tr '\n' ' '`

aws iam put-role-policy \
  --role-name $PREFIX-developers-on-production \
  --policy-▒▒▒▒ $PREFIX-write-to-production-repo \
  --policy-▒▒▒▒▒▒▒▒ "$S3_WRITE_PERMISSION_POLICY" \
  --profile daniella
```

* Feel free to check that the role has been created in the prod account using the [IAM service](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles/)

## Global admin workflow 4: letting developers assume the role

Daniella has no access to the development account, so she will need to ask Alice (our global
administrator overlord) to update the developers group so they can `assume` the role in the
production account


* Alice is going to create a *permission policy* so the developers can have permission to `assume` the role generated by Daniella

```bash
cat << EOF > assume-role-permission-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AssumeDeveloperRoleOnProduction$RANDOM",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::$PROD_ACCOUNT:role/$PREFIX-developers-on-production"
    }    
  ]
}
EOF
```

* Alice will now attach the policy to the developer group in the development account

```bash
ASSUME_PERMISSION_POLICY=`cat assume-role-permission-policy.json |  tr '\n' ' '`

aws iam put-group-policy \
--group-▒▒▒▒ ${PREFIX}-developers \
--policy-▒▒▒▒ ${PREFIX}-assume-role-dev-account \
--policy-▒▒▒▒▒▒▒ "$ASSUME_PERMISSION_POLICY" \
--profile alice-dev

```

## Developer workflow 2: publishing the application in production

This is an epic step! Bob, our famous developer, will finally be able to impersonate
himself in the production account and send the application artifact to its bucket.

* As bob, let's create a `.aws/config` file describing the role (the relevant information
has been provided by Daniella when she created it)

```bash
cat << EOF > ~/.aws/config
[profile bob-production]
role_arn=arn:aws:iam::$PROD_ACCOUNT:role/$PREFIX-developers-on-production
source_profile=bob
EOF
```

* Let's see if it is possible for him to assume the role (try it again after a few secons if you are
copy and pasting as crazy, as the IAM propagation takes some time)

```bash
aws sts get-caller-identity --profile bob-production
```

* Now, the so much anticipated moment: feel free to use Bob's role to upload the file to the
production bucket

```bash
aws s3 cp ./server.sh s3://$PROD_BUCKET_NAME --profile bob-production
```

## Resource based policies introduction

Emmet works at the company as security auditor. He has access to many accounts in the company,
including the development one (but not the production account) but he is not part of our developers team.
He has requested to Alice read-only access to the production bucket, but specifying that he only intends
to use that bucket from the company VPN.

Alice considers (maybe not very judiciously) that this is a good case for using *resource based
policies*.


## Emmet user registration

* Let's create a user for Emmet in the dev account and generate his credentials

```bash
aws iam create-user --user-name ${PREFIX}-Emmet --profile alice-dev
aws iam create-access-key \
  --user-name $PREFIX-Emmet \
  --profile alice-dev \
  | tee emmet.json

cat << EOF >> ~/.aws/credentials
[emmet]
aws_access_key_id=$(jq -r .AccessKey.AccessKeyId emmet.json)
aws_secret_access_key=$(jq -r .AccessKey.SecretAccessKey emmet.json)
EOF
```

* Of course, right now Emmet cannot access the production bucket:

```bash
aws s3 ls s3://$PROD_BUCKET_NAME --profile emmet
```

## Production bucket access policy configuration

* We will use our own IP to simulate the whitelisted addresses of the VPN

```bash
VPN_IP=$(curl -s httpbin.org/ip | jq .origin -r)
```

* Alice will create a *resource policy* allowing Emmet to read the production bucket only
from the specified IP


```bash
cat << EOF > emmet-prod-bucket-access-policy.json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "AllowReadAccessToProdBucketForEmmet",
         "Effect": "Allow",
         "Principal": {
            "AWS": "arn:aws:iam::$DEV_ACCOUNT:user/$PREFIX-Emmet"
         },
         "Action": [
                "s3:Get*",
                "s3:List*"
         ],
         "Resource": [
            "arn:aws:s3:::$PROD_BUCKET_NAME",
            "arn:aws:s3:::$PROD_BUCKET_NAME/*"
         ],
         "Condition": {
             "IpAddress": {
                 "aws:SourceIp": "$VPN_IP/32"
             }
         }
      }
   ]
}
EOF
```

* Now it's time to attach the policy to the bucket in the production account

```bash
S3_EMMET_ACCESS_POLICY=`cat emmet-prod-bucket-access-policy.json |  tr '\n' ' '`

aws s3api put-bucket-policy \
  --bucket $PROD_BUCKET_NAME \
  --policy "$S3_EMMET_ACCESS_POLICY" \
  --profile alice-prod
```

* Emmet can try to use the production bucket using his user in the development acount, but it will fail

```bash
aws s3 ls s3://$PROD_BUCKET_NAME --profile emmet
```

## Emmet user update

* The problem is that Emmet user permissions are checked before the resource policy, and  Emmet doesn't
have access to the S3 API. Let's solve this:

```bash
echo The S3 full access policy ARN is $S3_FULL_ACCESS_POLICY.

aws iam attach-user-policy \
  --user-name $PREFIX-Emmet \
  --policy-arn $S3_FULL_ACCESS_POLICY \
  --profile alice-dev
```

* Now Emmet can try it again: big success!

```bash
aws s3 ls s3://$PROD_BUCKET_NAME --profile emmet
```

## Policy refinaments

* Emmet is concerned about how a missconfiguration could provide a user with too many permissions. To calm him,
Alice improves the granularity of the production bucket policy:

```
cat << EOF > emmet-prod-bucket-access-policy.json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "AllowReadAccessToProdBucketForEmmet",
         "Effect": "Allow",
         "Principal": {
            "AWS": "arn:aws:iam::$DEV_ACCOUNT:user/$PREFIX-Emmet"
         },
         "Action": [
                "s3:Get*",
                "s3:List*"
         ],
         "Resource": [
            "arn:aws:s3:::$PROD_BUCKET_NAME",
            "arn:aws:s3:::$PROD_BUCKET_NAME/*"
         ],
         "Condition": {
             "IpAddress": {
                 "aws:SourceIp": "$VPN_IP/32"
             }
         }
      },
      {
         "Sid": "DenyOtherOpsToProdBucketForEmmet",
         "Effect": "Deny",
         "Principal": {
            "AWS": "arn:aws:iam::$DEV_ACCOUNT:user/$PREFIX-Emmet"
         },
         "NotAction": [
                "s3:Get*",
                "s3:List*"
        ],
         "Resource": [
            "arn:aws:s3:::$PROD_BUCKET_NAME",
            "arn:aws:s3:::$PROD_BUCKET_NAME/*"
         ]
      }
   ]
}
EOF
```

* Update the production bucket policy with the new restrictions

```bash
S3_EMMET_ACCESS_POLICY=`cat emmet-prod-bucket-access-policy.json |  tr '\n' ' '`

aws s3api put-bucket-policy \
  --bucket $PROD_BUCKET_NAME \
  --policy "$S3_EMMET_ACCESS_POLICY" \
  --profile alice-prod
```

## Other considerations

We are sad to say Dave was fired in the middle of this tutorial.
