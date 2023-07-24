# Quay
## Requirements
```
[root@lab centos]# ls /root/ssl/quay.mylab.local.crt 
/root/ssl/quay.mylab.local.crt
[root@lab centos]# ls /root/ssl/quay.mylab.local.key 
/root/ssl/quay.mylab.local.key
[root@lab centos]# ls /root/ssl/rootCA.crt 
/root/ssl/rootCA.crt
```
## Installation
Start QUAY
```
[root@lab mylab]# virsh start quay
Domain 'quay' started

[root@lab mylab]# virsh domstate quay
running

[root@lab mylab]# virsh dumpxml quay | grep vnc
    <graphics type='vnc' port='5904' autoport='yes' listen='127.0.0.1'>

```

```
[root@lab mylab]# ansible-playbook -i inventory playbooks/quay.yaml 
```
## Verification
define quay in your /etc/hosts
```
[root@lab centos]# curl -I https://quay.mylab.local/
HTTP/2 200 
```
