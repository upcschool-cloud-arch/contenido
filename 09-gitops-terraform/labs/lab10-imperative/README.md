# Imperative problems

This laboratory will help you to practice imperative automation, and
also will point some of its limitations.

## Preparations

* Ensure you are using version 2 of the AWS CLI

```bash
sudo apt update
sudo apt install -y unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install \
  --bin-dir /usr/local/bin \
  --install-dir /usr/local/aws-cli \
  --update

aws --version
```

## Fixing the script

[create-vpc-redacted.sh](./create-vpc-redacted.sh) contains the instructions required
for creating a *VPC* and a *security group*. To give you the opportunity of practicing
your automation skills, parts of the script are redacted. **Use the
[CLI documentation](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/index.html#cli-aws-ec2)
to replace the obfuscated text with the correct one**.

*Tip*: start the process by running each statement of the script one after
the next, to ensure the correctness of the syntax.

*Tip*: if you become absolutely desperate,
[create-vpc-solution.sh](./create-vpc-solution.sh) contains a ciphered
solution that can be viewed with 
`cat create-vpc-solution.sh | tr '[x-za-w]' '[a-z]'`.

## Limitations of the imperative approach

We need to change the opened port on the security group. What would happen
if you edit the file, modify 80 for 443 and then execute it again?

Instead of proceeding that way, write another script to remove the old
rule and apply the new one.

Finally, what would you need to do in order to create another copy of
the infrastructure? (for example, to create a *dev* environment).