# More info: https://serverfault.com/a/783175

# Send side: Start compressing and pipe to netcat listen server
sudo tar -zc $DIR_PATH | nc -N -l -p $PORT

# Receive side: Get data from send side then extract data
nc -d $Send_side_IP $Send_side_PORT | sudo tar -zxv
