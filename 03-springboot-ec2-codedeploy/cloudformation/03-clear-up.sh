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

# for not versioned bucket
#aws s3 rm s3://${BUCKET_NAME} --recursive

S3OBJECTS=`aws s3api list-object-versions \
  --bucket ${BUCKET_NAME}|jq -r '{Objects:.Versions|map({Key:.Key,VersionId:.VersionId}),Quiet:true}'`

echo $S3OBJECTS
if [ `echo $S3OBJECTS|jq -r '.|length'` -gt 0 ]
then
  #echo 'delete...'
  aws s3api delete-objects \
    --profile cloudformation-deployment \
    --bucket ${BUCKET_NAME} \
    --delete "${S3OBJECTS}"
fi

aws s3 rb s3://${BUCKET_NAME} --force

for LOG_GROUP in $(aws logs describe-log-groups \
    --query 'logGroups[].logGroupName' --output text)
do
    #echo ${LOG_GROUP}
    aws logs delete-log-group \
        --log-group-name ${LOG_GROUP}
done

