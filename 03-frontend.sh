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

dnf list installed nginx &>> $log_file
if [ $? -eq 0 ]
then
    echo -e "nginx Already Installed...$Y SKIPPING $N" 
else
    dnf install nginx -y &>> $log_file
    validate $? "Installation of nginx is"
fi

systemctl enable nginx &>>$log_file
validate $? "Enabling nginx"

systemctl start nginx &>>$log_file
validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$log_file
validate $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$log_file
validate $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
validate $? "Extracting frontend code"

#check your repo and path
cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
validate $? "Copied expense conf"

systemctl restart nginx &>>$log_file
validate $? "Restarting nginx"

echo "Script execution completed at:$timestamp" &>> $log_file