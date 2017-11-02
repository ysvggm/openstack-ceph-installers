#!/usr/bin/python2
import ConfigParser
import sys

if __name__ == "__main__":
	config = ConfigParser.RawConfigParser()
	config.read('/etc/cinder/cinder.conf')
	config.set('DEFAULT', 'enabled_backends', 'ceph')
	config.set('DEFAULT', 'glance_api_version', '2')
	config.set('DEFAULT', 'default_volume_type', 'ceph')
	config.set('DEFAULT', 'backup_driver', 'cinder.backup.drivers.ceph')
	config.set('DEFAULT', 'backup_ceph_user', 'cinder-backup')
	config.set('DEFAULT', 'backup_ceph_conf', '/etc/ceph/ceph.conf')
	config.set('DEFAULT', 'backup_ceph_chunk_size', '134217728')
	config.set('DEFAULT', 'backup_ceph_pool', 'backups')
	config.set('DEFAULT', 'backup_ceph_stripe_unit', '0')
	config.set('DEFAULT', 'backup_ceph_stripe_count', '0')
	config.set('DEFAULT', 'restore_discard_excess_bytes', 'true')
	config.add_section('ceph')
	config.set('ceph', 'volume_driver', 'cinder.volume.drivers.rbd.RBDDriver')
	config.set('ceph', 'rbd_cluster_name', 'ceph')
	config.set('ceph', 'volume_backend_name', 'ceph')
	config.set('ceph', 'rbd_pool', 'volumes')
	config.set('ceph', 'rbd_user', 'cinder')
	config.set('ceph', 'rbd_ceph_conf', '/etc/ceph/ceph.conf')
	config.set('ceph', 'rbd_flatten_volume_from_snapshot', 'false')
	config.set('ceph', 'rbd_secret_uuid', sys.argv[1])
	config.set('ceph', 'rbd_max_clone_depth', '5')
	config.set('ceph', 'rbd_store_chunk_size', '4')
	config.set('ceph', 'rados_connect_timeout', '-1')
	
	with open('/etc/cinder/cinder.conf', 'wb') as configfile:
		config.write(configfile)
	
	config1 = ConfigParser.RawConfigParser()
	config1.read('/etc/glance/glance-api.conf')
	config1.set('DEFAULT', 'stores', 'rbd')
	config1.set('DEFAULT', 'default_store', 'rbd')
	config1.set('DEFAULT', 'rbd_store_chunk_size', '8')
	config1.set('DEFAULT', 'rbd_store_pool', 'images')
	config1.set('DEFAULT', 'rbd_store_user', 'glance')
	config1.set('DEFAULT', 'rbd_store_ceph_conf', '/etc/ceph/ceph.conf')
	config1.set('DEFAULT', 'show_image_direct_url', 'True')
	
	with open('/etc/glance/glance-api.conf', 'wb') as configfile:
		config1.write(configfile)

	config2 = ConfigParser.RawConfigParser()
	config2.read('/etc/nova/nova.conf')
	config2.set('libvirt', 'images_type', 'rbd')
	config2.set('libvirt', 'images_rbd_pool', 'vms')
	config2.set('libvirt', 'images_rbd_ceph_conf', '/etc/ceph/ceph.conf')
	config2.set('libvirt', 'rbd_user', 'cinder')
	config2.set('libvirt', 'rbd_secret_uuid', sys.argv[1])
	config2.set('libvirt', 'disk_cachemodes', '\"network=writeback\"')
	config2.set('libvirt', 'inject_password', 'False')
	config2.set('libvirt', 'inject_key', 'False')
	config2.set('libvirt', 'inject_partition', '-2')
	config2.set('libvirt', 'live_migration_flag', '\"VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST,VIR_MIGRATE_TUNNELLED\"')
	config2.set('libvirt', 'hw_disk_discard', 'unmap')
	
	with open('/etc/nova/nova.conf', 'wb') as configfile:
		config2.write(configfile)
	
	config3 = ConfigParser.RawConfigParser()
        config3.read('/etc/ceph/ceph.conf')
        config3.add_section('client')
        config3.set('client', 'rbd cache', 'true')
        config3.set('client', 'rbd cache writethrough until flush', 'true')
        config3.set('client', 'rbd concurrent management ops', '20')
        config3.set('client', 'admin socket', '/var/run/ceph/guests/$cluster-$type.$id.$pid.$cctid.asok')
        config3.set('client', 'log file', '/var/log/ceph/qemu-guest-$pid.log')

	with open('/etc/ceph/ceph.conf', 'wb') as configfile:
		config3.write(configfile)
