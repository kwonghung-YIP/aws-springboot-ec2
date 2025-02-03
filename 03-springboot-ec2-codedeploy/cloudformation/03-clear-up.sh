#!/bin/bash

STACK_NAME=springboot-ec2-stack
ARTIFACTS_BUCKET=SpringbootArtifactsBucket

BUCKET_NAME=`aws cloudformation describe-stack-resource \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME} \
    --logical-resource-id ${ARTIFACTS_BUCKET} \
    --query 'StackResourceDetail.PhysicalResourceId' --output text`

aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME}

aws s3 rm s3://${BUCKET_NAME} --recursive

sleep 15

aws s3 rb s3://${BUCKET_NAME} --force