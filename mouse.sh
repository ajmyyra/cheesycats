#!/bin/bash

# mouse.sh - cheese-loving Mousie Mouse

trap "ssh ukko003 pkill -u $(whoami) nc" 2

portnumber=$(<nc_port_number)

# TODO select random machine from ukkonodes to log in to, save to file so can be cleaned

ssh ukko003 nc -l $portnumber -k| while read msg;
  do
    echo "Received message: $msg"
    if [[ $msg == "MEOW" ]]; then
      attacker=$(ssh ukko003 ps -u $(whoami) | grep "chase_cat.sh" | awk '{print $1}')
      echo "Got caught! Sending SIGINT to $attacker"
      ssh ukko003 kill -2 $attacker
    fi
  done

