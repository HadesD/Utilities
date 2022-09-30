#!/bin/bash

# Will kill APP_GREP_NAME which run at APP_PWD then re-run it again

APP_GREP_NAME=$1
APP_PWD=$2

if [ "${APP_GREP_NAME}" == "" ] || [ "${APP_PWD}" == "" ]; then
  echo 'You must enter param[0] = APP_GREP_NAME and param[1] = APP_PWD'
  exit 1
fi

kill $(pwdx $(pgrep ${APP_GREP_NAME}) | grep "${APP_PWD}" | cut -f1 -d\:)
${APP_GREP_NAME}
