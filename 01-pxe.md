# PXE
## Requirements

```
[root@lab centos]# ls /root/virsh/images/CentOS-Stream-9-20230417.0-x86_64-boot.iso
/root/virsh/images/CentOS-Stream-9-20230417.0-x86_64-boot.iso
```

## Install
```
[root@lab pxe]# virsh start pxe
Domain 'pxe' started

[root@lab mylab]# virsh domstate pxe
running
```
Use VNC, first check the port 
```

[root@lab pxe]# virsh dumpxml pxe | grep vnc
    <graphics type='vnc' port='5900' autoport='yes' listen='127.0.0.1'>
```
if you need proxy confiugration on your ~/.ssh/config
```
Host kvm-jump
  HostName <yourIP>
  User root
  LocalForward 5900 127.0.0.1:5900
```
and
```
ssh kvm-jump
```
On vnc viewer add : 127.0.0.1:5900

Use GUI to install the web server (Network is configured with dhcp)
```
virsh net-dumpxml pxe
```

```
[root@lab mylab]# ssh-copy-id 172.16.1.10
```

```
[root@lab mylab]# ansible-playbook -i inventory playbooks/pxe.yaml
```

## Verification
```
virsh start quay
```

Quay is installing and in pxe server
```
# /var/log/messages
Jun 30 15:16:43 pxe dhcpd[45541]: DHCPDISCOVER from 52:54:00:36:79:9d via enp1s0
Jun 30 15:16:43 pxe dhcpd[45541]: DHCPOFFER on 172.16.1.50 to 52:54:00:36:79:9d via enp1s0
Jun 30 15:16:43 pxe dhcpd[45541]: DHCPREQUEST for 172.16.1.50 (172.16.1.10) from 52:54:00:36:79:9d via enp1s0                                                                                                     
Jun 30 15:16:43 pxe dhcpd[45541]: DHCPACK on 172.16.1.50 to 52:54:00:36:79:9d via enp1s0
```
