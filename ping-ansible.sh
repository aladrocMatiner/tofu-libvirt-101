#!/bin/bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini ping.yaml