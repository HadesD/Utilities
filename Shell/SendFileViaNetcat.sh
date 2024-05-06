# More info: https://serverfault.com/a/783175

# Send side
tar -zcf - DIR_PATH | sudo nc -N -l 9998

# Receive side
