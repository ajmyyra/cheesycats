#!/bin/bash

# listy.sh - Attentive Listy Cat
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# When ended with SIGINT, will cleanup location file and message queue
function finished {
  rm cmsg
  rm listy_location
}
trap finished 2

# Saving port number for nc usage and location to file for others to use
portnumber=$(<nc_port_number)
echo $(hostname) > listy_location
echo "Listening for messages at $(hostname)"

# Listening on the specified port and logging incoming messages from Catty and Jazzy
nc -l $portnumber -k| while read msg;
  do
    echo "Received message: $msg"
    echo $msg >> cmsg
  done

