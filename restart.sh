#!/bin/bash
systemctl restart openstack-cinder-volume
systemctl restart openstack-cinder-backup
systemctl restart openstack-glance-api
systemctl restart openstack-nova-compute
