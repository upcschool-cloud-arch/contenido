# DynamoDB

This laboratory will explore how it is possible to easily reach thousands
of writes per second with a very simple configuration, using DynamodDB.


## Prerequisites

**Skip this section if you have access to your workstation instance, as it
already contains everything needed to run the rest of the laboratory.**

You will need an instance to create the DynamoDB table and to run
the application that will write data on it. If you can't use your
workstation (as it is adviced), an alterantive is to create a
temporal operation instance running the next commands in CloudShell:

* Find the id of the profile created by AWSAcademy. It will be used to assign
permissions to the operations instance. If you are running this lab in your own
account, you will need to create a *role* and an instance profile the name
`LabInstanceProfile` instead.

```bash
PROFILE=$(aws iam get-instance-profile \
  --instance-profile-name LabInstanceProfile \
  --query InstanceProfile.Arn \
  --output text)
```

* Start the instance

```bash
EC2=$(aws ec2 run-instances \
    --image-id ami-06a1f46caddb5669e \
    --instance-type t3.large \
    --iam-instance-profile  '{"Name": "LabInstanceProfile"}' \
    --query Instances[0].InstanceId \
    --output text)

echo Use session manager to connect to instance $EC2 using next link: https://us-east-1.console.aws.amazon.com/systems-manager/session-manager/$EC2?region=us-east-1.
```

* Wait until the instance is ready. Then, **use the link provided by the 
output of the last command to jump into the operations instance**. The next orders should
be executed there, as it is in the same network than the cluster and because of that we
can establish connectivity to it.

* Change from the SSM user to the ubuntu one

```bash
sudo su ubuntu
cd
```

* Install the `jq` and `aws` tools

```bash
sudo apt update 
sudo apt-get install jq awscli -y
```

* Install node

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install --lts
```

## Table creation

We will create a table with a *primary key* named `uuid` (user id) and
an *order key* called `timestamp`. It will contain the information of all
Pokémon captured by that particular user, ordered by the date in which they
were caught.

* Set the region for the lab

```bash
export AWS_DEFAULT_REGION=us-east-1
```

* Initialize the table

```bash
aws dynamodb create-table \
  --table-name pokemondb \
  --attribute-definitions 'AttributeName=uuid, AttributeType=S' 'AttributeName=timestamp, AttributeType=N' \
  --key-schema 'AttributeName=uuid, KeyType=HASH' 'AttributeName=timestamp, KeyType=RANGE' \
  --provisioned-throughput 'ReadCapacityUnits=5, WriteCapacityUnits=30000' 
```

* Wait until the table is provisioned with the demanded capacity (press `ctrl`+`c`
to get back the prompt)

```bash
watch aws dynamodb describe-table --table-name pokemondb --query Table.TableStatus
```

* Update the capacity model so you pay only when you actually read or write
to the table. The desired max capacity will remain for a few minutes, so we should
be able to use those 30K write capacity units

```bash
aws dynamodb update-table --table-name pokemondb --billing-mode PAY_PER_REQUEST
```

## Application initialization

* Download the code

```bash
git clone https://github.com/ciberado/dynamodbdemo && cd dynamodbdemo
```

* Initalize the dependencies

```bash
npm install
```

## Writing to the database

Unfortunately, `t3.large` instance CPUs are not enough to saturate the table capacity,
so we are *only* going to write 15K times per second. Feel free to launch two
instances to write over that limit

* Start capturing Pokémon for `60` seconds, writing `15000` items each one of them:

```bash
node index.js  -t pokemondb -s 60 -p 15000 -r us-east-1
```


## Reading from the database

* Use the CLI to retrieve on random item from the table

```bash
aws dynamodb scan \
  --table-name pokemondb \
  --max-items 1 \
  --query Items[0] \
  | jq
```

## Clean up

* Delete the table

```bash
aws dynamodb delete-table --table-name pokemondb
```

* **Only if you created a temporal operations instance instead of using
your workstation**, terminate that instance:

```bash
aws ec2 terminate-instances --instance-ids $EC2
```