#!/bin/bash

# cordy.sh - overseeing Cordy Cat
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# Initializing the hunt, loading ukkonodes
IFS=$'\n' nodes=($(<ukkonodes))

# Search loop, to search for the mouse through the cluster
for i in "${nodes[@]}"
do
  while true; do
    if [ -f cmsg ]; then # process the log events added to file by Listy
      IFS=$'\n' msgs=($(<cmsg))
      for a in "${msgs[@]}"
      do
        OIFS=$IFS
        IFS=" "
        columns=($a) # splits the message line into columns
        if [[ ${columns[0]} == "N" ]]; then
          echo "No mouse on ${columns[1]}, reported by ${columns[2]}"
          rm ${columns[2]}.lock # Remove the lockfile, allowing the cat to be sent again
        else # With search, we only get either N or F
          echo "Mousie Mouse is hiding on ${columns[1]}, reported by ${columns[2]}. Let's go get it!"
          rm ${columns[2]}.lock
          finder=${columns[2]}
          target=${columns[1]}
          break 3
        fi
        IFS=$OIFS
        sleep 4 # As the instructions demand
      done
      rm cmsg # we have the log events, so we don't need to process them again
    fi

    if [ ! -f "Jazzy.lock" ]; then
      catname="Jazzy"
      break
    elif [ ! -f "Catty.lock" ]; then
      catname="Catty"
      break
    else
      sleep 1 # No cats available to do anything, sleeping
    fi
  done
  echo "Sending $catname to node $i"
  echo $i > $catname.lock
  ssh -o StrictHostKeyChecking=no $i "cd /cs/work/scratch/$(whoami); ./chase_cat.sh S $catname" &
done

# Checking if loop ended without valid target (either mouse not found or it is in one of the last two nodes)
if [[ ! -n "${target+1}" ]]; then
  counter=0
  while true; do
    if [ -f cmsg ]; then
      IFS=$'\n' msgs=($(<cmsg))
      rm cmsg
      for a in "${msgs[@]}"
      do
        OIFS=$IFS
        IFS=" "
        columns=($a) # splits the message line into columns
        if [[ ${columns[0]} == "N" ]]; then
          echo "No mouse on ${columns[1]}, reported by ${columns[2]}"
          counter=$((counter+1))
          rm ${columns[2]}.lock # Remove the lockfile, allowing the cat to be sent again
        else # With search, we only get either N or F
          echo "Mousie Mouse is hiding on ${columns[1]}, reported by ${columns[2]}. Let's go get it!"
          rm ${columns[2]}.lock
          finder=${columns[2]}
          target=${columns[1]}
          break 3
        fi
        IFS=$OIFS
      done
    else
      sleep 4 # Waiting for the last two to report in
      if (( $counter >= 2 )); then
        break 3 # The mouse isn't available
      fi
    fi
  done
fi

if [[ ! -n "${target+1}" ]]; then # The mouse isn't there. Elusive little bugger.
  echo "Mouse not found (404)"
  exit 1
fi

# Catching the mouse once it has been found
if [[ $finder == "Jazzy" ]]; then
  attacker="Catty"
else
  attacker="Jazzy"
fi

while true; do
  if [ ! -f "$attacker.lock" ]; then
      break
  else
    if grep -q -e "$attacker" "cmsg"; then # If other cat has reported to Listy, it's available for use
      rm $attacker.lock
    else
      sleep 4
    fi
  fi
done

rm cmsg # No need for the older events
echo "Sending $attacker to confirm mouse report by $finder."
echo $target > $attacker.lock
ssh -o StrictHostKeyChecking=no $target "cd /cs/work/scratch/$(whoami); ./chase_cat.sh S $attacker" &

while true; do
  if [ -f cmsg ]; then
    rm $attacker.lock
    line=$(<cmsg)
    OIFS=$IFS
    IFS=" "
    columns=($line) # splits the message line into columns
    if [[ ${columns[0]} == "F" ]]; then
      echo "Confirmation from $attacker, mouse found!"
      rm cmsg
      echo "Attacking mouse on node $target with $attacker Cat."
      ssh -o StrictHostKeyChecking=no $target "cd /cs/work/scratch/$(whoami); ./chase_cat.sh A $attacker" &
      IFS=$OIFS
      break
    fi
  else
    sleep 1
  fi
done

while true; do
  if [ -f cmsg ]; then
    break
  else
    sleep 1
  fi
done

line=$(<cmsg)
OIFS=$IFS
IFS=" "
columns=($line) # splits the message line into columns
if [[ ${columns[0]} == "G" ]]; then
  echo "Mouse catch confirmed! Cordy Cat signing off."
else
  echo "Something went wrong, here's the last message from $attacker: $line"
fi
IFS=$OIFS

