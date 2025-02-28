#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-0275e6067c2c2beb3

#For mysql or mongodb the instance type should be t3.micro else t2.micro

for i in "${NAMES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="T3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instances"
    aws ec2 run-instances --image-id $IMAGE_ID --instance-type t2.micro --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done