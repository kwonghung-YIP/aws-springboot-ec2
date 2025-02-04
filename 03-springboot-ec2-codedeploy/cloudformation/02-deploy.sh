#!/bin/bash

STACK_NAME=springboot-ec2-stack
ARTIFACTS_BUCKET=SpringbootArtifactsBucket
DEPLOYMENT_GROUP=CodeDeployDeploymentGroup

BUCKET_NAME=`aws cloudformation describe-stack-resource \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME} \
    --logical-resource-id ${ARTIFACTS_BUCKET} \
    --query 'StackResourceDetail.PhysicalResourceId' --output text`

DEPLOY_GROUP_NAME=`aws cloudformation describe-stack-resource \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME} \
    --logical-resource-id ${DEPLOYMENT_GROUP} \
    --query 'StackResourceDetail.PhysicalResourceId' --output text`

cd ../simple-springboot-app

mvn -U clean package

cp target/*.jar ../codedeploy

cd ../cloudformation

rm application.tar*

#zip application.zip ../codedeploy/*
tar -cvf application.tar -C ../codedeploy .

aws s3 cp ./application.tar s3://${BUCKET_NAME}/application.tar

DEPLOY_ID=`aws deploy create-deployment \
    --profile cloudformation-deployment \
    --description "My First Deployment" \
    --application-name springboot-application \
    --deployment-group-name ${DEPLOY_GROUP_NAME} \
    --s3-location bucket=${BUCKET_NAME},key=application.tar,bundleType=tar \
    --query 'deploymentId' --output text`

echo $DEPLOY_ID