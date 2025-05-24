#!/bin/bash

source ./common.sh
app_name=shipping

check_root
echo "Please enter root password to setup"
read -s harsha123

app_setup
maven_setup
systemd_setup

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "Install MySQL"

mysql -h mysql.harshavn24.site -u root -p$harsha123 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.harshavn24.site -uroot -p$harsha123 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.harshavn24.site -uroot -p$harsha123 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h mysql.harshavn24.site -uroot -p$harsha123 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Loading data into MySQL"
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restart shipping"

print_time