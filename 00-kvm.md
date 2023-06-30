# KVM

## Installation

```
[root@lab centos]# ansible-playbook -i inventory playbooks/kvm.yaml                                                                                                                                                
                                                                                                                                                                                                                   
PLAY [Install & configure KVM] ************************************************************************************************************************************************************************************[...]
changed: [kvm] => (item={'name': 'okd-worker0', 'path_xml': '/root/virsh/vms', 'memory': 8, 'cpu': 4, 'volume': [{'name': 'okd-worker0', 'size_gb': 30, 'path_volume': '/home/pools/okd-worker0', 'path_xml': '/root/virsh/volumes', 'dev': 'vda', 'device': 'disk', 'bus': 'virtio'}], 'network': [{'name': 'openshift', 'mac_address': '52:54:00:15:FA:57'}]})

PLAY RECAP ********************************************************************************************************************************************************************************************************
kvm                        : ok=21   changed=18   unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   

```

### Verification
```
[root@lab centos]# virsh list --all
 Id   Name                    State
----------------------------------------
 -    bind                    shut off
 -    okd-bastion             shut off
 -    okd-bootstrap           shut off
 -    okd-master0             shut off
 -    okd-master1             shut off
 -    okd-master2             shut off
 -    okd-worker0             shut off
 -    overcloud-compute0      shut off
 -    overcloud-controller0   shut off
 -    overcloud-controller1   shut off
 -    overcloud-controller2   shut off
 -    proxy                   shut off
 -    pxe                     shut off
 -    quay                    shut off
 -    undercloud              shut off
```
