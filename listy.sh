#!/bin/bash

# listy.sh - Attentive Listy Cat

trap "rm cmsg; rm listy_location" 2

portnumber=$(<nc_port_number)
echo $(hostname) > listy_location

nc -l $portnumber -k| while read msg;
  do
    echo "Received message: $msg"
    echo $msg >> cmsg
  done

