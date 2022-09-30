#!/bin/bash

# Will kill APP_GREP_NAME which run at APP_PWD then re-run it again

APP_GREP_NAME=$1
APP_PWD=$2

if [ "${APP_GREP_NAME}" == "" ] || [ "${APP_PWD}" == "" ]; then
  echo 'Sample: ./restart_app_with_pwd.sh XXXTool /vav/www/xxx.com'
  exit 1
fi

if [ ! -d "${APP_PWD}" ]; then
  echo "Dir not found: ${APP_PWD}"
  exit 1
fi

cd ${APP_PWD}

if ! command -v ${APP_GREP_NAME} &> /dev/null; then
  echo "Command not found: ${APP_GREP_NAME}"
  exit 1
fi

echo "Restarting ${APP_GREP_NAME} in ${APP_PWD}"

kill $(pwdx $(pgrep ${APP_GREP_NAME}) | grep "${APP_PWD}" | cut -f1 -d\:)
${APP_GREP_NAME}
