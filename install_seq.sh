#!/bin/bash

echo "Install target is: " $1
ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rwx pool=vms, allow rx pool=images'
ceph auth get-or-create client.cinder-backup mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups'
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images'
ceph auth get-or-create client.cinder | ssh $1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh $1 chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh $1 tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh $1 chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.glance | ssh $1 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh $1 chown glance:glance /etc/ceph/ceph.client.glance.keyring
ceph auth get-key client.cinder | ssh $1 tee client.cinder.key
uuid=`cat uuid-secret.txt`
echo "uuid:  " $uuid
scp uuid-secret.txt root@$1:/root/
scp secret.xml root@$1:/root/
scp remote.sh root@$1:/root/
scp setcfg.py root@$1:/root/
scp restart.sh root@$1:/root/
ssh $1 /root/remote.sh
ssh $1 mkdir -p /var/run/ceph/guests/ /var/log/ceph/
ssh $1 chown qemu:libvirt /var/run/ceph/guests /var/log/ceph/
ssh $1 /root/setcfg.py $uuid
ssh $1 /root/restart.sh
