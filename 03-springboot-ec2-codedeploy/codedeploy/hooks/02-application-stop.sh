#!/bin/bash

function log {
    msg="[`date '+%Y-%m-%d %H:%M:%S'`]: $1"
    echo ${msg}
}

log ${DEPLOYMENT_ID}-${LIFECYCLE_EVENT}

DEPLOY_DIR="/springboot-app"
SPRINGBOOT_PID=`cat /springboot-app/app.pid`

echo "kill java process $SPRINGBOOT_PID ..."

kill -9 $SPRINGBOOT_PID