#!/bin/bash
echo "restarting services..."
echo "restart openstack-cinder-volume"
systemctl restart openstack-cinder-volume
echo "restart openstack-cinder-backup"
systemctl restart openstack-cinder-backup
echo "restart openstack-glance-api"
systemctl restart openstack-glance-api
echo "restart openstack-nova-compute"
systemctl restart openstack-nova-compute
