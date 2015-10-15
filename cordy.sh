#!/bin/bash

# cordy.sh - overseeing Cordy Cat
# Created by Antti Myyrä for the course Distributed Systems, fall 2015

# TODO everything

ssh -o StrictHostKeyChecking=no ukko186 /bin/bash 
cd "/cs/work/scratch/$(whoami)"
ps -u ajmyyra # ./someaction.sh 'some params' toimii sit

