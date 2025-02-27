#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
#/home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
        echo -e "$2....$R FAILURE $N"
    else
        echo -e "$2----$G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "installing rpm node resource"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "installing nodejs"

# Need to write a condition to check user is already existed or not
useradd roboshop &>>$LOGFILE

# Need to write a condition to check directory is already existed or not
mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloading catalogue service"

cd /app &>>$LOGFILE

VALIDATE $? "moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unziping the catalouge file"

cd /app &>>$LOGFILE

VALIDATE $? "moving into app directory"

npm install &>>$LOGFILE

VALIDATE $? "installing the npm"

cp /home/centos/roboshop-shell/catalogue.servuce /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying the catalouge.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "doing the daemon-reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enabling the catalogue service"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "starting the catalogue service"

cp /home/centos/roboshop-shell/mongo.rep /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "starting the catalogue service"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing the mongodb-org-shell"

mongo --host mongodb.masterdevops.site </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading the schema"



