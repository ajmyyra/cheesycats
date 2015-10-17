#!/bin/bash

# cordy.sh - overseeing Cordy Cat
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# Initialize the hunt, load ukkonodes
IFS=$'\n' nodes=($(<ukkonodes))

# Search loop, to search for the mouse through the cluster
for i in "${nodes[@]}"
do
  # Choose a cat and save under catname. Check that cat is available (lockfile)
  catname="Jazzy"
  echo "Sending $catname to node $i" # Ukkonode in question
done

# ssh -o StrictHostKeyChecking=no ukko186 "cd /cs/work/scratch/$(whoami); ./chase_cat.sh S $catname"
# ./someaction.sh 'some params' toimii sit

# Attack loop, to catch the mouse
