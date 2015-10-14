#!/bin/bash

ssh -o StrictHostKeyChecking=no ukko186 /bin/bash << EOF
cd "/cs/work/scratch/$(whoami)"
ps -u ajmyyra # ./someaction.sh 'some params' toimii sit
EOF

