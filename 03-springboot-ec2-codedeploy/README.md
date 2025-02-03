## Clear up
```bash
aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name springboot-ec2-stack

aws s3 rm s3://bucket-name --recursive

aws s3 rb s3://amzn-s3-demo-bucket --force  
```

## For testing the AWS::CloudFormation::Init config in EC2 instance
```bash
sudo cfn-init -v \
    --stack=springboot-ec2-stack \
    --region=eu-north-1 \
    --resource=springbootLaunchTemplate

sudo cfn-get-metadata \
    --stack=springboot-ec2-stack \
    --region=eu-north-1 \
    --resource=springbootLaunchTemplate
```

## Install codedeploy-agent locally
```bash
sudo yum install ruby
wget https://aws-codedeploy-eu-north-1.s3.eu-north-1.amazonaws.com/latest/install
chmod +x install
sudo ./install auto
```

```bash
aws deploy create-deployment \
    --application-name springboot-application \
    --s3-location bucket=springboot-ec2-stack-springbootartifactsbucket-wvkav1gfsryi,key=application.zip,bundleType=zip
```

## Reference
- [Install the CodeDeploy agent for Amazon Linux or RHEL](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html)
- [Resource kit bucket names by Region](https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names)
- [AWS CodeDeploy - AppSpec 'hooks' section](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#appspec-hooks-server)