read -p 'REDIRECT_TO_CADDR: ' CADDR
read -p 'REDIRECT_TO_CPORT: ' CPORT
read -p "LISTEN_PORT[${CPORT}]: " LPORT

redir -n --caddr="${CADDR}" --lport=${LPORT} --cport=${CPORT} > "${LPORT}_${CADDR}_${CPORT}.log"
