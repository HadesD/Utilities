#!/bin/bash

# Will kill APP_GREP_NAME which run at APP_PWD then re-run it again

APP_GREP_NAME=$1
APP_PWD=$2

kill $(pwdx $(pgrep ${APP_GREP_NAME}) | grep "${APP_PWD}" | cut -f1 -d\:)
${APP_GREP_NAME}
