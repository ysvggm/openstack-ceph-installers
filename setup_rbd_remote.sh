#!/bin/bash

echo "Install target is: " $1
scp setup_rbd.sh root@$1:/root/
ssh $1 /root/setup_rbd.sh $1
