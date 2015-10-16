#!/bin/bash

# mouse.sh - cheese-loving Mousie Mouse
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# When ended with SIGINT, will cleanup its location file and nc from the remote node
function finished {
  ssh -o StrictHostKeyChecking=no $(<mouse_location) pkill -u $(whoami) nc
  rm mouse_location
}
trap finished 2

# Saving port number for some ssh action, and creating a random number generator for choosing the node
portnumber=$(<nc_port_number)
random=$$$(date +%s)

# Going through ukkonodes and selecting one randomly to hide into
IFS=$'\n' nodes=($(<ukkonodes))
node=${nodes[$random % ${#nodes[@]} ] }
echo "Going to $node to eat some cheese (and to hide from cats)."
echo "$node" > mouse_location

# Going to the specified node and listening in on any possible attacking cats
ssh -o StrictHostKeyChecking=no $node nc -l $portnumber -k| while read msg;
  do
    echo "Received message: $msg"
    if [[ $msg == "MEOW" ]]; then
      attacker=$(ssh -o StrictHostKeyChecking=no $node ps -u $(whoami) | grep "chase_cat.sh" | awk '{print $1}')
      echo "Got caught! Sending SIGINT to $attacker"
      ssh -o StrictHostKeyChecking=no $node kill -2 $attacker
    fi
  done

