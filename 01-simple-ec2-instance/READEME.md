```bash
aws ssm get-parameters-by-path \
    --path /aws/service/ami-amazon-linux-latest \
    --query 'Parameters[].Name'
```

```bash
aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file template.yaml \
    --stack-name simple-ec2-instance \
    --role-arn arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution --debug

# To get the new keypair Id generated in the cloudformation template
aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=sshKeyForEC2 \
    --query 'KeyPairs[].KeyPairId' --output text

# Extract the primary key form systems parameters properties
aws ssm get-parameter \
    --name /ec2/keypair/key-0029f7eee2d4f4601 \
    --with-decryption --query Parameter.Value --output text > ~/.ssh/id_ed25519

# Change the ssh private key file and not allow access by others
chmod 700 ~/.ssh/id_ed25519

ssh ec2-user@<ec2-instancepublic-up>

# ssh-keygen -t ed25519 -C "hung.yip@example.com"

aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name simple-ec2-instance \
    --role-arn arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution
```

## Reference
- [Amazon Elastic Compute Cloud Document](https://docs.aws.amazon.com/ec2/)
- [CloudFormation Reference - AWS::EC2::Instance](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html)
- [Using System Manager Parameter as an alias for AMI ID](https://aws.amazon.com/blogs/compute/using-system-manager-parameter-as-an-alias-for-ami-id/)
- [Get the private key from the keypair created in cloudformation template](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
- [Amazon EC2 CloudFormation template snippets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-ec2-instance-config.html)

