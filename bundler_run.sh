#! /bin/bash
APP_NAME=$1
EXEC=$2
shift 2
PARAMS=$@

cd $APP_NAME
bundle exec ./$EXEC $PARAMS
