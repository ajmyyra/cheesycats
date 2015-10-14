#!/bin/bash

# chase_cat.sh - driven Catty Cat & urban Jazzy Cat

# TODO make cats act on parameters given (./chase_cat S Jazzy)
# Can find mouse with ps -f -u ajmyyra|grep "nc -l 31337" or with netstat

trap "echo 'F $(hostname) Jazzy'| nc -w 1 $(<listy_location) $(<nc_port_number); echo Caught SIGINT" 2

portnumber=$(<nc_port_number)

echo "MEOW" | nc -w 1 localhost $portnumber
sleep 8

# Actual cat :)
#while true
#do
#	sleep 1
#done


