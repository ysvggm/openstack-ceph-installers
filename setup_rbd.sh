#!/bin/bash

echo "Create rbd drive on : " $1
echo "Default size is 200G"
image_name=$1-rbd1
echo $image_name > image_name.txt
mount_point="/mnt/esms-ephemeral-disk"
echo $mount_point > mount_point.txt
rbd create $image_name --size 20480
rbd feature disable rbd/$image_name deep-flatten
rbd feature disable rbd/$image_name fast-diff
rbd feature disable rbd/$image_name object-map
rbd feature disable rbd/$image_name exclusive-lock
rbd map --image $image_name
mkfs.xfs /dev/rbd0
mkdir $mount_point
mount /dev/rbd0 $mount_point
cat > /usr/bin/mount-rbd-$image_name <<EOF
#!/bin/bash
# Image mount/unmount and pool are passed from the systems service as arguments
# Determine if we are mounting or unmounting
if [ "\$1" == "m" ]; then
   mkdir /var/run/ceph/guests
   modprobe rbd
   rbd map --pool rbd `cat image_name.txt` --id admin --keyring /etc/ceph/ceph.client.admin.keyring
   mkdir -p `cat mount_point.txt`
   mount /dev/rbd/rbd/`cat image_name.txt` `cat mount_point.txt`
fi
if [ "\$1" == "u" ]; then
   umount `cat mount_point.txt`
   rbd unmap /dev/rbd/rbd/`cat image_name.txt`
fi
EOF
chmod a+x /usr/bin/mount-rbd-$image_name
cat > /etc/systemd/system/mount-rbd-$image_name.service <<EOF
[Unit]
Description="RADOS block device mapping for `cat image_name.txt` in pool rbd"
Conflicts=shutdown.target
Wants=graphical.target
After=ceph-mon@`hostname`.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/mount-rbd-`cat image_name.txt` m
ExecStop=/usr/bin/mount-rbd-`cat image_name.txt` u
[Install]
WantedBy=graphical.target
EOF

systemctl enable mount-rbd-$image_name.service



