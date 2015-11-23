#! /bin/bash

# For some reason the HOME env variable is set to '/home/' (while user is 'hadoop')
# It also seems that something has changed since past versions and .bash_profile isn't run
HOME=/home/$USER
. $HOME/.bash_profile

APP_NAME=$1
EXEC=$2
shift 2
PARAMS=$@

cd $APP_NAME
bundle exec ./$EXEC $PARAMS
