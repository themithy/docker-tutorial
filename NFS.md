# Network file system

Install *glusterfs*:
```
apt-get install glusterfs-server

systemctl enable glusterd
systemctl start glusterd
```

Check another machine whether *glusterfs* is accessible:
```
gluster peer probe IP_ADDR
```

Create the volume on master host:
```
gluster volume create VOL_NAME [replica NO] HOST1:/gluster/VOLUME_NAME [HOST2:/gluster/VOLUME_NAME ...]
```

The file system can work in a *distributed* or/and *replicated* mode. The
distributed mode creates one big volume that encompasses multiple host, but if
one hosts fails data goes down. The replicated modules allows for failure but
is resource-consuming.

For example create a volume across 3 hosts with a replica:
```
gluster volume create tutorial replica 2 \
 host1:/gluster/tutorial host2:/gluster/tutorial host3:/gluster/tutorial
```
In this example 3 hosts would store the data with 2 replicas, which means that
one host can go down data corruption.

Mount the volume on worker host:
```
mount.glusterfs IP_ADDR:/VOLUME_NAME MOUNT_POINT
```
