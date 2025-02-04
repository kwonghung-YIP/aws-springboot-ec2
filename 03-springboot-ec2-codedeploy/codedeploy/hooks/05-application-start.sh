#!/bin/bash

function log {
    msg="[`date '+%Y-%m-%d %H:%M:%S'`]: $1"
    echo ${msg}
}

log ${DEPLOYMENT_ID}-${LIFECYCLE_EVENT}

DEPLOY_DIR="/springboot-app"

nohup java -jar $DEPLOY_DIR/simple-springboot-app-0.0.1-SNAPSHOT.jar > $DEPLOY_DIR/app.log 2>&1 & echo $! > $DEPLOY_DIR/app.pid