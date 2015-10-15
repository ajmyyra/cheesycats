#!/bin/bash

# chase_cat.sh - driven Catty Cat & urban Jazzy Cat
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# Informing Listy after receiving SIGINT (result from attacking mouse.sh)
function got_mouse {
  echo 'G $(hostname) $(<attacking_cat)'| nc -w 1 $(<listy_location) $(<nc_port_number)
  echo "Caught SIGINT (probably from Mousie Mouse)"
  rm attacking_cat
}
trap got_mouse 2

# Exit if no correct parameters are given
if (( $# != 2 )); then
  echo "Usage: `basename $0` Command CatName"
  echo "To search with Jazzy: `basename $0` S Jazzy"
  echo "To attack with Catty: `basename $0` A Catty"
  exit
fi

# Cats can only search or attack
if [[ ! $1 == "S" ]]; then
  if [[ ! $1 == "A" ]]; then
    echo "We can only search(S) or attack(A)"
    echo "We're cats. You really expect us to $1?"
    exit
  fi
fi

# There are only Catty and Jazzy for mouse operations
if [[ ! $2 == "Catty" ]]; then
  if [[ ! $2 == "Jazzy" ]]; then
    echo "We don't have a cat named $2"
    exit
  fi
fi

# Variables for operations
portnumber=$(<nc_port_number)
operation=$1
catname=$2

# Searching a node, searching for mouse listening on the specified port
# Result is reported to Listy via nc
if [[ operation == "S" ]]; then
  sleep 12
  ps -f -u $(whoami) > temp_output
  if [[ grep --quiet "nc -l $portnumber" temp_output ]]; then
    result="F $(localhost) $catname"
  else
    result="N $(localhost) $catname"
  fi

  echo $result | nc -w 1 $(<listy_location) $(<nc_port_number)
  rm temp_output
fi

# Attacking mouse on a node with MEOW. Attacking cat is saved to file for SIGINT actions
if [[ operation == "A" ]]; then
  sleep 6
  echo $catname > attacking_cat
  echo "MEOW" | nc -w 1 localhost $portnumber
  sleep 8
fi

