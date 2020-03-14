#!/bin/bash

# This bash script requires:
# + jq JSON processor to process JSON files. Refer to https://stedolan.github.io/jq.
# + AWS CLI 2 to call AWS APIs. Refer to https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
# + "aws configure" on Jenkins machine
# + RegisterTaskDefinition access level. Refer to https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RegisterTaskDefinition.html

# Exit immediately if a command exits with a non-zero status.
set -e

# 1) Prepare parameters
imageUri=$1
echo "imageUri = "$imageUri
projectName=$2
echo "projectName = "$projectName
clusterName=$3
echo "clusterName = "$clusterName

# 2) Replace "<imageUri>"" within "taskDefinitionTemplate.json" with $imageUri and create temporary a task definition file
containerDefinitionName=$projectName
echo 'Creating a temporary Task Definition file from Task Definition template'
jq \
--arg containerDefinitionName "$containerDefinitionName" \
--arg imageUri "$imageUri" \
'select(.containerDefinitions[].name == $containerDefinitionName) | .containerDefinitions[].image = $imageUri' \
taskDefinitionTemplate.json > taskDefinitionToRegister.json

# 3) Register new revision of Task Definition
echo 'Registering new ECS Task Definition'
family=$projectName
taskVersion=`aws ecs register-task-definition --family $family --cli-input-json 'file://'taskDefinitionToRegister.json | jq '.taskDefinition.revision'`
echo "Registered ECS Task Definition: " $taskVersion

# 4) Clean up after registering task definition.
echo 'Removing the temporary Task Definition file'
rm taskDefinitionToRegister.json

# 5) Update ECS service
serviceName=$projectName
deployedService=`aws ecs update-service --cluster $clusterName --service $serviceName --task-definition $family:$taskVersion --force-new-deployment | jq '.service.serviceName'`
echo "Deployed $deployedService"
