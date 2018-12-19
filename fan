#!/bin/bash
### BEGIN INIT INFO
# Provides:          fan
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Start/stop fan
### END INIT INFO
temp=0
status=0
gpio mode 1 out
case "$1" in
start)  echo "Starting the fan!"
				gpio write 1 1
;;
stop) 	echo "Stopping the fan!"
				gpio write 1 0
;;
service) 	echo "Starting the fan service!"
					while true
					do
						temp=$(vcgencmd measure_temp|awk -F "=" '{print $2}'|awk -F "." '{print $1}')
						echo "Current temperature is: $temp C° "
						if [ $temp -ge 41 ] && [ $status -ne 1 ]
						then
							echo "Fan must be turned on!"
							gpio write 1 1
							status=1
						elif [ $temp -lt 41 ] && [ $status -ne 0 ]
						then
							echo "Fan must be turned off!"
							gpio write 1 0
							status=0
						fi
						sleep 1m
					done
;;
*)      echo "Usage: /etc/init.d/fan.sh {start|stop|service}"
        exit 2
        ;;
esac
exit 0
