# More info: https://serverfault.com/a/783175

# Send side: Start compressing and pipe to netcat listen server
tar -zcf - $DIR_PATH | sudo nc -N -l $PORT

# Receive side: Get data from send side then extract data
nc -d $Send_side_IP $Send_side_PORT | tar -zxv
