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

# User functions
check_root() {
    if [ $user_id -ne 0 ]
    then
        echo "Please run this script with root access."
        exit 1 # manually exit if error comes.
    else
        echo "You are super user."
    fi
}


validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCESS $N"
    fi
}

