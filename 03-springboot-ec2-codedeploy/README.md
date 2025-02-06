## Features covered in this example
- Create 3 Springboot EC2 instances and expose to public via an Application Load Balancer
- It is a simple Springboot application implements a RestController and enable the Actuator for monitoring
- The EC2 instances configuration are shared by a EC2 launch template (AWS::EC2::LaunchTemplate)
- CloudWatch agent and Systems Manager (SSM) agent are installed into EC2 instances via AWS::CloudFormation::Init for capture the application logs and metrics
- A CodePipeline is created to automated the deployment from GitHub repo to EC2 instances
- The Build stage in the pipeline appoints a CodeBuild project to build the Springboot package with Maven
- The Deploy stage in the pipeline use CodeDeploy to install the Springboot package into all EC2 instances
- Create above infrastructure with a CloudFormation template

## Prerequistie
- Install AWS CLI, JDK 21, Maven, and jq
- Configure the local AWS CLI SSO login, and grant permissions to the account to create the stack

## Create the CloudFormation stack with AWS CLI

- Just run the following script that will deploy the stack, and download the new SSH Key into the home folder.
- The CodePipeline with be triggered after create and deploy the springboot application.

cloudformation/(01-launch-stack.sh)[cloudformation/01-launch-stack.sh]

## Invoke the CodeDeploy via AWS CLI and deploy from local

- Build the Springboot jar with maven in local
- Pack the deployment package including the jar, CodeDeploy lifecycle hook scripts, and CodeDeploy appspec.yml
- Upload the package to the S3 artifacts bucket created in the stack
- Invoke the CodeDeploy by AWS CLI

cloudformation/(02-deploy.sh)[cloudformation/02-deploy.sh]

## Clear up

- Delete the stack
- Empty the artifact bucket and delete it
- Delete all CloudWatch log groups

cloudformation/(03-clear-up.sh)[cloudformation/03-clearup.sh]

## Other scripts
```bash
# For testing the AWS::CloudFormation::Init config in EC2 instance
sudo cfn-init -v \
    --stack=springboot-ec2-stack \
    --region=eu-north-1 \
    --resource=SpringbootLaunchTemplate

sudo cfn-get-metadata \
    --stack=springboot-ec2-stack \
    --region=eu-north-1 \
    --resource=SpringbootLaunchTemplate

# Install codedeploy-agent locally
sudo yum install ruby
wget https://aws-codedeploy-eu-north-1.s3.eu-north-1.amazonaws.com/latest/install
chmod +x install
sudo ./install auto

# Create CodeDeploy deployment after upload the package to artifacts bucket
aws deploy create-deployment \
    --application-name springboot-application \
    --s3-location bucket=springboot-ec2-stack-springbootartifactsbucket-wvkav1gfsryi,key=application.zip,bundleType=zip

# List all CloudWatch log group
aws logs describe-log-groups \
    --query 'logGroups[].logGroupName' --output text
```

## Reference
- [Install the CodeDeploy agent for Amazon Linux or RHEL](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html)
- [Resource kit bucket names by Region](https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names)
- [AWS CodeDeploy - AppSpec 'hooks' section](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#appspec-hooks-server)
- [Step 4: Create an IAM instance profile for your Amazon EC2 instances](https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-iam-instance-profile.html)
- [Collect metrics, logs, and traces with the CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)