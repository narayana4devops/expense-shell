#!/bin/bash

source ./06-common.sh

check_root

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

#rm -rf /usr/share/nginx/html/* &>>$log_file
#validate $? "Removing existing content"

#curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$log_file
#validate $? "Downloading frontend code"

#cd /usr/share/nginx/html &>>$log_file
#unzip /tmp/frontend.zip &>>$log_file
#validate $? "Extracting frontend code"

#check your repo and path
#cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
#validate $? "Copied expense conf"

#systemctl restart nginx &>>$log_file
#validate $? "Restarting nginx"

echo "Script execution completed at:$timestamp" &>> $log_file