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

echo "Please enter DB password:"
read -s mysql_root_password

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

dnf list installed mysql-server &>> $log_file
if [ $? -eq 0 ]
then
    echo -e "mysql-server Already Installed...$Y SKIPPING $N" 
else
    dnf install mysql-server -y &>> $log_file
    validate $? "Installation of mysql-server is"
fi

systemctl enable mysqld &>> $log_file
validate $? "enable of mysql-server is"

systemctl start mysqld &>> $log_file
validate $? "start of mysql-server is"

#We need to change the default root password in order to start using the database service.
#mysql_secure_installation --set-root-pass ExpenseApp@1

#Below code will be useful for idempotent nature
mysql -h db.daws78s1.online -uroot -p${mysql_root_password} -e 'show databases;' &>> $log_file
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
    validate $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi

echo -e "\n"
echo "Script execution completed at:$timestamp" &>> $log_file