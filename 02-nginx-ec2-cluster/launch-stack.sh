#!/bin/bash

SSH_KEY_NAME=sshKeySpringbootEC2
CFN_EXECUTION_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file template.yaml \
    --stack-name nginx-ec2-stack \
    --role-arn ${CFN_EXECUTION_ROLE_ARN} \
    --parameter-overrides sshKeyName=${SSH_KEY_NAME} #--debug

# To get the new keypair Id generated in the cloudformation template
KEYPAIR_ID=`aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=${SSH_KEY_NAME} \
    --query 'KeyPairs[].KeyPairId' --output text`

echo $KEYPAIR_ID

# Extract the primary key form systems parameters properties
aws ssm get-parameter \
    --name /ec2/keypair/${KEYPAIR_ID} \
    --with-decryption --query Parameter.Value --output text > ~/.ssh/id_ed25519

# Change the ssh private key file and not allow access by others
chmod 700 ~/.ssh/id_ed25519

# Report the Stack Output, include the public DNS of the Application Load Balancer
aws cloudformation describe-stacks \
    --profile cloudformation-deployment \
    --stack-name nginx-ec2-stack \
    --query 'Stacks[0].Outputs[].OutputValue' \
    --no-cli-pager