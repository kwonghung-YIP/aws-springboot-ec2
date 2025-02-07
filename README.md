## Deploy a simple Springboot application into AWS EC2 instances

One of the approaches for running Springboot application on AWS is to deploy it into EC2 cluster and serves it with a Application Load Balancer (ALB).

This repo give examples in different levels, and finally we automated the deployment with AWS CI/CD.

All examples come with a CloudFormation template and serve the IaC purpose.


## [01-simple-ec2-instance](01-simple-ec2-instance/README.md)
First example to deploy a single EC2 instance with CloudFormation template.

## [02-nginx-ec2-cluster](02-nginx-ec2-cluster/README.md)
Deploy 3 Nginx EC2 instances and an ALB, shared the common EC2 configure with an EC2 launch template.

## [03-springboot-ec2-codedeploy](03-springboot-ec2-codedeploy)
Deploy a SpringBoot cluster, and automated the deployment with CodePipeline, CodeBuild, CodeDeploy.