#!/bin/bash

GN_PATH="$1"

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"


. $GN_PATH/config/settings.ini

LOG_FILE="$GN_PATH/var/log/install_monitoring_oedic.log"

echo Create schema_oedic.sql


echo "Create oedic schema..." > $LOG_FILE
echo "--------------------" &>> $LOG_FILE
echo "" &>> $LOG_FILE
export PGPASSWORD=$user_pg_pass;psql -h $db_host -U $user_pg -d $db_name -f $SCRIPTPATH/data/schema_oedic.sql  &>> $LOG_FILE

echo Import data

echo "Import oedic data" &>> $LOG_FILE
echo "--------------------" &>> $LOG_FILE
echo "" &>> $LOG_FILE
# export PGPASSWORD=$user_pg_pass;psql -h $db_host -U $user_pg -d $db_name -f $SCRIPTPATH/data/data_oedic.sql  &>> $LOG_FILE
export PGPASSWORD=$user_pg_pass;psql -h $db_host -U $user_pg -d $db_name -f $SCRIPTPATH/data/data_oedic.sql

echo Import data site


echo create views

echo "Create oedic views" &>> $LOG_FILE
echo "--------------------" &>> $LOG_FILE
echo "" &>> $LOG_FILE
export PGPASSWORD=$user_pg_pass;psql -h $db_host -U $user_pg -d $db_name -f $SCRIPTPATH/data/views_oedic.sql  &>> $LOG_FILE
