#!/bin/bash

source ./common.sh
app_name=mysql
check_root

echo "Please enter root password to setup"
read -s harsha123

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling MySQL"

systemctl start mysqld   &>>$LOG_FILE
VALIDATE $? "Starting MySQL"

mysql_secure_installation --set-root-pass $harsha123 &>>$LOG_FILE
VALIDATE $? "Setting MySQL root password"

print_time