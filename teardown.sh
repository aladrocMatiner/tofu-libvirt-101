#!/bin/bash
tofu destroy -auto-approve

virsh list --all

virsh destroy ubuntu-demo  # if it's running
virsh undefine ubuntu-demo --remove-all-storage

virsh list --all
