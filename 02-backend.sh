#!/bin/bash

#user variables
user_id=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
script_name=$(echo $0 | cut -d "." -f1)
log_file=/tmp/$script_name-$timestamp.log

# For Debug purpose
#echo "time: $timestamp"
#echo "script_name: $script_name"
echo "Script execution started at:$timestamp" &>> $log_file
echo -e "\n"

# Variables for colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $user_id -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

# User functions
validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCESS $N"
    fi
}

dnf module disable nodejs -y &>> $log_file
validate $? "disable of default nodejs is"

dnf module enable nodejs:20 -y &>> $log_file
validate $? "Enabling nodejs:20 version"

dnf list installed nodejs &>> $log_file
if [ $? -eq 0 ]
then
    echo -e "nodejs Already Installed...$Y SKIPPING $N" 
else
    dnf install nodejs -y &>> $log_file
    validate $? "Installation of nodejs is"
fi

id expense &>> $log_file
if [ $? -ne 0 ]
then
    useradd expense &>> $log_file
    validate $? "creating expense user is"
else
     echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>> $log_file
validate $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $log_file
validate $? "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$log_file
validate $? "Extracted backend code"

#dnf list installed npm &>>$log_file
#if [ $? -eq 0 ]
#then
#    echo -e "npm Already Installed...$Y SKIPPING $N" 
#else
#    dnf install npm -y &>> $log_file
#    validate $? "Installation of npm is"
#fi
npm install &>>$log_file
validate $? "Installing nodejs dependencies"

#check your repo and path
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>> $log_file
validate $? "Copied backend service"

systemctl daemon-reload &>>$log_file
validate $? "Daemon Reload"


systemctl enable backend &>> $log_file
validate $? "enable of backend is"

dnf list installed mysql &>>$log_file
if [ $? -eq 0 ]
then
    echo -e "mysql Already Installed...$Y SKIPPING $N" 
else
    dnf install mysql -y &>> $log_file
    validate $? "Installation of mysql is"
fi

mysql -h db.daws78s1.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
validate $? "Schema loading"

systemctl restart backend &>>$log_file
validate $? "Restarting Backend"

echo -e "\n"
echo "Script execution completed at:$timestamp" &>> $log_file