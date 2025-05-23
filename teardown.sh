#!/bin/bash
tofu destroy -auto-approve

virsh list --all

virsh destroy opensuse-demo  # if it's running
virsh undefine opensuse-demo --remove-all-storage

virsh list --all
