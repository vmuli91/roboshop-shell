#!/bin/bash

NAMES=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-0275e6067c2c2beb3
DOMAIN_NAME=masterdevops.site
HOSTED_ZONE_ID=Z0054923J2O4K3M5H15Y

#For mysql or mongodb the instance type should be t3.micro else t2.micro

for i in $@
do
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="T3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instances"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done


# imporvement
# check instance is already created or not
# check route53 record is already exist, if exist update, otherwise create route53 record