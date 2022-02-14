#!/bin/bash


###########To update packages#################

sudo apt update -y



#############To check if apache is installed or not############### :-

INS=$(dpkg --get-selections | grep "apache2")

if [ -z "$INS" ]
then
        sudo apt-get install apache2 -y
fi


##############To check if apache is running or not########################### :-

RUNNING_STATUS="$(systemctl is-active apache2)"

if [ "$RUNNING_STATUS" != "active" ]
then
        sudo service apache2 start
fi

#############To check latest status of apache2############

RUNNING_STATUS="$(systemctl is-active apache2)"
echo $RUNNING_STATUS


#To that the server runs on restart/reboot, I.e., it checks whether the service is enabled or not. It enables the service if not enabled already.

ENABLE_STATUS="$(systemctl is-enabled apache2)"

if [ "$ENABLE_STATUS" != "enabled" ]
then
        sudo systemctl enable apache2
fi


#########To check latest status whether the service is enabled or not##############

ENABLE_STATUS="$(systemctl is-enabled apache2)"

echo $ENABLE_STATUS



########Create a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory#############

myname="Ankit"
timestamp=$(date '+%d%m%Y-%H%M%S')

find /var/log/apache2/ -name '*.log' | tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log*



###########Place tar into /tmp directory####################

mv ${myname}-httpd-logs-${timestamp}.tar /tmp/



#############Then move the tar file to the s3 bucket#################3

s3_bucket="upgrad-ankit"

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
