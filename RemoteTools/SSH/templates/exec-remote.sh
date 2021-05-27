#!/bin/bash

#_SELF="${0##*/}"
_SELF=$(basename $0)
REMOTE_SERVER_NAME=${_SELF/".sh"/""}
SSH_KEY_FILE="../Keys/${REMOTE_SERVER_NAME}.pem"

if [[ "$CONN_TYPE" == "" ]]; then
  read -p '[+] Choose connection type:
- [1] SSH
- [2] WinSCP
Default[1]: ' CONN_TYPE
fi

ENDPOINT_URL="${REMOTE_SERVER_USERNAME}:$REMOTE_SERVER_PASSWORD@${REMOTE_SERVER_HOST}:${REMOTE_SERVER_PORT}"

if [[ "$CONN_TYPE" == "2" ]]; then
  echo [+] WinSCP to $ENDPOINT_URL
  PPK_KEY_FILE="../Keys/${REMOTE_SERVER_NAME}.ppk"
  PASSWORD_FLAG="-password=\"$REMOTE_SERVER_PASSWORD\""
  if [ -x "$(command -v wine)" ]; then
    if [ ! -f "${PPK_KEY_FILE}" ]; then
      wine ../WinSCP/WinSCP.com /keygen "$(winepath --windows ${SSH_KEY_FILE})" /output="$(winepath --windows ${PPK_KEY_FILE})"
    fi
	if [ -f "${PPK_KEY_FILE}" ]; then
		PASSWORD_FLAG="-privatekey="$(winepath --windows ${PPK_KEY_FILE})""
	fi
    wine ../WinSCP/WinSCP.exe $PASSWORD_FLAG -privatekey="$(winepath --windows ${PPK_KEY_FILE})" sftp://${REMOTE_SERVER_USERNAME}@${REMOTE_SERVER_HOST}:${REMOTE_SERVER_PORT} -sessionname="${REMOTE_SERVER_NAME}"
  else
    if [ ! -f "${PPK_KEY_FILE}" ]; then
      ../WinSCP/WinSCP.com -keygen "${SSH_KEY_FILE}" -output="${PPK_KEY_FILE}"
    fi
	if [ -f "${PPK_KEY_FILE}" ]; then
		PASSWORD_FLAG="-privatekey="${PPK_KEY_FILE}""
	fi
    ../WinSCP/WinSCP.exe $PASSWORD_FLAG "sftp://${REMOTE_SERVER_USERNAME}@${REMOTE_SERVER_HOST}:${REMOTE_SERVER_PORT}" -sessionname="${REMOTE_SERVER_NAME}"
  fi
else
  SSH_APPEND_FLAGS="-XY -o ServerAliveInterval=30 ${REMOTE_SERVER_USERNAME}@${REMOTE_SERVER_HOST} -p ${REMOTE_SERVER_PORT}"

  if [[ -f ${SSH_KEY_FILE} ]]; then
    chmod 0600 ${SSH_KEY_FILE}
    SSH_APPEND_FLAGS="$SSH_APPEND_FLAGS -i ${SSH_KEY_FILE}"
  fi
  LANG=C.UTF-8
  LC_CTYPE=C.UTF-8
  echo [+] SSH to $ENDPOINT_URL
  ssh ${SSH_APPEND_FLAGS}
fi
