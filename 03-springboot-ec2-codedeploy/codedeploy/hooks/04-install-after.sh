#!/bin/bash

function log {
    msg="[`date '+%Y-%m-%d %H:%M:%S'`]: $1"
    echo ${msg}
}

log ${DEPLOYMENT_ID}-${LIFECYCLE_EVENT}