# bash redir.sh -l xxx -h xxx -p xxx

while getopts l:h:p: flag
do
    case "${flag}" in
        l) LPORT=${OPTARG};;
        h) CADDR=${OPTARG};;
        p) CPORT=${OPTARG};;
    esac
done

#read -p 'REDIRECT_TO_CADDR: ' CADDR
#read -p 'REDIRECT_TO_CPORT: ' CPORT
#read -p "LISTEN_PORT[${CPORT}]: " LPORT

redir -n --caddr="${CADDR}" --lport=${LPORT} --cport=${CPORT} > "${LPORT}_${CADDR}_${CPORT}.log"
