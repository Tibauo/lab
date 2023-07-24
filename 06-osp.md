### OpenStack
#### Installation
```
[root@lab mylab]# virsh start undercloud
Domain 'undercloud' started

[root@lab mylab]# virsh domstate undercloud
running

[root@lab mylab]# virsh dumpxml undercloud | grep vnc
    <graphics type='vnc' port='5905' autoport='yes' listen='127.0.0.1'>
```

Add pool_ids in host_vars/undercloud
```
[root@lab mylab]# ansible-playbook -i inventory playbooks/undercloud.yaml -e vbmc=true
```


```
[root@lab pxe]# virsh list --all | grep overcloud
 -    overcloud-controller0   shut off
 -    overcloud-controller1   shut off
 -    overcloud-controller2   shut off

[root@lab pxe]#  for i in 0 1 2; do qemu-img create -f qcow2 -o preallocation=metadata /home/pools/overcloud-controller${i} 60G; done
Formatting '/home/pools/overcloud-controller0', fmt=qcow2 cluster_size=65536 extended_l2=off preallocation=metadata compression_type=zlib size=64424509440 lazy_refcounts=off refcount_bits=16
Formatting '/home/pools/overcloud-controller1', fmt=qcow2 cluster_size=65536 extended_l2=off preallocation=metadata compression_type=zlib size=64424509440 lazy_refcounts=off refcount_bits=16
Formatting '/home/pools/overcloud-controller2', fmt=qcow2 cluster_size=65536 extended_l2=off preallocation=metadata compression_type=zlib size=64424509440 lazy_refcounts=off refcount_bits=16


[root@lab pxe]# ls -l /home/pools/overcloud-controller*
-rw-r--r--. 1 root root 64434601984 Jan 23 12:00 /home/pools/overcloud-controller0
-rw-r--r--. 1 root root 64434601984 Jan 23 12:00 /home/pools/overcloud-controller1
-rw-r--r--. 1 root root 64434601984 Jan 23 12:00 /home/pools/overcloud-controller2
```


```
[root@undercloud ~]# systemctl status vbmcd
● vbmcd.service - vbmc service
   Loaded: loaded (/etc/systemd/system/vbmcd.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2023-01-23 11:52:50 CET; 6min ago
 Main PID: 98920 (vbmcd)
    Tasks: 3 (limit: 93998)
   Memory: 24.8M
      CPU: 1.261s
   CGroup: /vbmc.slice/vbmcd.service
           └─98920 /usr/bin/python3.6 /usr/local/bin/vbmcd --foreground

Jan 23 11:52:50 undercloud.monlab.local systemd[1]: Started vbmc service.
Jan 23 11:52:51 undercloud.monlab.local vbmcd[98920]: 2023-01-23 11:52:51,269 98920 INFO VirtualBMC [-] Started vBMC server on port 50891

[root@undercloud ~]# ssh-copy-id 10.1.1.1
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '10.1.1.1 (10.1.1.1)' can't be established.
ECDSA key fingerprint is SHA256:k++4NnYX1h43czpmT24k6xsjLP2mJ0BCz3Tjh8PoGDw.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@10.1.1.1's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '10.1.1.1'"
and check to make sure that only the key(s) you wanted were added.

[root@undercloud ~]# for i in 0 1 2; do vbmc add overcloud-controller$i --port 600$(($i + 1)) --username admin --password admin --libvirt-uri qemu+ssh://root@10.1.1.1/system; done
[root@undercloud ~]# for i in 0 1 2; do vbmc start overcloud-controller$i; done
[root@undercloud ~]# vbmc list
+-----------------------+---------+---------+------+
| Domain name           | Status  | Address | Port |
+-----------------------+---------+---------+------+
| overcloud-controller0 | running | ::      | 6001 |
| overcloud-controller1 | running | ::      | 6002 |
| overcloud-controller2 | running | ::      | 6003 |
+-----------------------+---------+---------+------+

[root@undercloud ~]# for i in 1 2 3; do ipmitool -I lanplus -U admin -P admin -H 127.0.0.1 -p 600${i} power status; done
Chassis Power is off
Chassis Power is off
Chassis Power is off

[root@undercloud ~]# su - stack
Last login: Mon Jan 23 12:14:16 CET 2023 on pts/0
[stack@undercloud ~]$ source stackrc 
(undercloud) [stack@undercloud ~]$ openstack overcloud node import --introspect --provide nodes.yaml
Waiting for messages on queue 'tripleo' with no timeout.


3 node(s) successfully moved to the "manageable" state.
Successfully registered node UUID 51ce255d-5d14-48fe-9050-f70a68ca3caa
Successfully registered node UUID 89334f29-6f56-406c-8d23-49c11c18de97
Successfully registered node UUID f49159c4-eca3-464d-8f54-f6151371e7e1
Waiting for introspection to finish...
Waiting for messages on queue 'tripleo' with no timeout.
Introspection of node completed:51ce255d-5d14-48fe-9050-f70a68ca3caa. Status:SUCCESS. Errors:None
Introspection of node completed:f49159c4-eca3-464d-8f54-f6151371e7e1. Status:SUCCESS. Errors:None
Introspection of node completed:89334f29-6f56-406c-8d23-49c11c18de97. Status:SUCCESS. Errors:None
Successfully introspected 3 node(s).
Waiting for messages on queue 'tripleo' with no timeout.
3 node(s) successfully moved to the "available" state.

(undercloud) [stack@undercloud ~]$ openstack baremetal node list
+--------------------------------------+-----------------------+---------------+-------------+--------------------+-------------+
| UUID                                 | Name                  | Instance UUID | Power State | Provisioning State | Maintenance |
+--------------------------------------+-----------------------+---------------+-------------+--------------------+-------------+
| 51ce255d-5d14-48fe-9050-f70a68ca3caa | overcloud-controller0 | None          | power off   | available          | False       |
| 89334f29-6f56-406c-8d23-49c11c18de97 | overcloud-controller1 | None          | power off   | available          | False       |
| f49159c4-eca3-464d-8f54-f6151371e7e1 | overcloud-controller2 | None          | power off   | available          | False       |
+--------------------------------------+-----------------------+---------------+-------------+--------------------+-------------+

(undercloud) [stack@undercloud ~]$ for NODE in 0 1 2; do openstack baremetal node set --property capabilities="profile:control,boot_option:local" overcloud-controller$NODE; done
(undercloud) [stack@undercloud ~]$ openstack overcloud profiles list
+--------------------------------------+-----------------------+-----------------+-----------------+-------------------+
| Node UUID                            | Node Name             | Provision State | Current Profile | Possible Profiles |
+--------------------------------------+-----------------------+-----------------+-----------------+-------------------+
| 51ce255d-5d14-48fe-9050-f70a68ca3caa | overcloud-controller0 | available       | control         |                   |
| 89334f29-6f56-406c-8d23-49c11c18de97 | overcloud-controller1 | available       | control         |                   |
| f49159c4-eca3-464d-8f54-f6151371e7e1 | overcloud-controller2 | available       | control         |                   |
+--------------------------------------+-----------------------+-----------------+-----------------+-------------------+
```


## Overcloud

```
[stack@undercloud ~]$ cd /usr/share/openstack-tripleo-heat-templates
[stack@undercloud openstack-tripleo-heat-templates]$ ./tools/process-templates.py -o ~/openstack-tripleo-heat-templates-rendered

```


