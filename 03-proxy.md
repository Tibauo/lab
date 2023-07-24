# Proxy

## Installation

Start vm
```
[root@lab mylab]# virsh start proxy
Domain 'proxy' started

[root@lab mylab]# virsh domstate proxy
running

[root@lab mylab]# virsh dumpxml proxy | grep vnc
    <graphics type='vnc' port='5901' autoport='yes' listen='127.0.0.1'>
```

```
[root@lab mylab]# ansible-playbook -i inventory playbooks/proxy.yaml
[...]
PLAY RECAP ********************************************************************************************************************************************************************************************************
proxy                      : ok=6    changed=6    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0  
```

## Check
```
[root@lab pxe]# ssh 172.16.1.30
Last login: Mon Jan 23 00:41:09 2023 from 172.16.1.1
[root@proxy ~]# HTTP_PROXY="http://172.18.1.30:3128" HTTPS_PROXY="http://172.18.1.30:3128" curl -I https://www.centos.com
HTTP/1.1 200 Connection established
```
