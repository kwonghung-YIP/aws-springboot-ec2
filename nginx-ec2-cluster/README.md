## Features covered in this example
- Create 3 Nginx EC2 instances and serve public via an Application Load Balancer
- Deploy above setup with a CloudFormation stack
- Create EC2 instaces with EC2 launch template (AWS::EC2::LaunchTemplate) and CloudFormation helper scripts (AWS::CloudFormation::Init)
- Install Nginx, Corretto JDK 21, Maven, and other initial setup in latest Amazon Linux 2023 EC2 instance with cfn-init
- The stack including a new SSH Key, the launch-stack.sh download the new private key and configure the local SSH setup 

## Local and AWS IAM setup
- Install aws cli
- Create an user in IAM Identity Center for aws cli login, and grant with the following access
- Create a new CloudFormation Execution Role (IAM Role), and grant with the following access  

## Launch the stack (launch-stack.sh) 
```bash
SSH_KEY_NAME=sshKeySpringbootEC2
CFN_EXECUTION_ROLE_ARN=~Replace with your cloudformation execution role ARN~

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file template.yaml \
    --stack-name springboot-ec2-stack \
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
    --stack-name springboot-ec2-stack \
    --query 'Stacks[0].Outputs[].OutputValue' \
    --no-cli-pager
```

## Clear up
```bash
aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name springboot-ec2-stack
```

## Reference
- [Run commands when you launch an EC2 instance with user data input](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
- [Store instance launch parameters in Amazon EC2 launch templates](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html)
- [CloudFormation Reference - AWS::EC2::LaunchTemplate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-launchtemplate.html)
- [CloudFormation Helper Scripts](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html)
- [CloudFormation Reference - AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html)
- [Specify existing resources at runtime with CloudFormation-supplied parameter types](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-supplied-parameter-types.html)
- [GitHub - aws-cloudformation-template samples](https://github.com/aws-cloudformation/aws-cloudformation-templates)
- [yum command cheatsheet](https://access.redhat.com/sites/default/files/attachments/rh_yum_cheatsheet_1214_jcs_print-1.pdf)
- [Use instance metadata to manage your EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
- [AWS CloudFormation Templates for us-west-1](https://aws.amazon.com/cloudformation/templates/aws-cloudformation-templates-us-west-1/)
- [AWS - Create a scaled and load-balanced application](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/walkthrough-autoscaling.html)
- [CloudFormation Template sections](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)