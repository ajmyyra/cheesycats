Cheesy cats - A shell script story of 1 mouse and 4 cats inside a computing cluster

Written by Antti Myyrä for the University of Helsinki course Distributed Systems, fall 2015.
More information about the task can be found from http://www.cs.helsinki.fi/node/83199 (Exercise 2)

# actual cats can be defined in much simpler way :)
while true; do
  sleep 1
done

Known bugs:
- For some reason, cordy.sh caches cmsg availability (if [ -f cmsg]), causing longer waits than would be necessary.
