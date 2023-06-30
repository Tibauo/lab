#!/bin/bash

for i in $(virsh list --all --name); do  virsh destroy $i;  virsh undefine $i; done
for vol in $(virsh vol-list --pool lab_pool | tail -n +3 | awk '{print $1}'); do  virsh vol-delete --pool lab_pool $vol; done
for net in $(virsh net-list --name); do  virsh net-destroy $net;  virsh net-undefine $net; done
virsh pool-destroy lab_pool
virsh pool-delete lab_pool
