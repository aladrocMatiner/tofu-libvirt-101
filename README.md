# tofu-libvirt-101

# | Installing Tofu
Recomend a tool called tenv:

```bash
#!/bin/bash
LATEST_VERSION=$(curl --silent https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r .tag_name)
curl -O -L "https://github.com/tofuutils/tenv/releases/latest/download/tenv_${LATEST_VERSION}_amd64.deb"
sudo dpkg -i "tenv_${LATEST_VERSION}_amd64.deb"
```

Then run this command and select the versions of the tofu terraform terragrunt atmos to be installed:
```
tenv
```
# | Config the pool

``` bash
## List all pools
virsh pool-list --all

## If pool is not activated
virsh pool-start default
virsh pool-autostart default

## If pool is missing need to create
virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
virsh pool-build default
virsh pool-start default
virsh pool-autostart default

```

# | Running commands

```bash
## Follow the yellow brick road and you'll arrive in Oz.
tofu init
tofu plan
tofu apply -auto-approve
``` 

```bash
## Nuke resources out
tofu destroy -auto-approve

## Check if something left (normally is)
virsh list --all

## Take it manually
virsh destroy ubuntu-demo  # if it's running
virsh undefine ubuntu-demo --remove-all-storage
```
u can also use the teardown.sh to be faster

# | Cloud Init


```
vm_name = "ubuntu-demo"
memory  = 2048
vcpu    = 2
```

# | Known problems

All the stones in the road i found

## | Missing dependencies
```bash
sudo apt update
sudo apt install genisoimage
```

## | Missing permisions




```bash
sudo chown -R libvirt-qemu:kvm /var/lib/libvirt
```

```bash
sudo visudo
<<YourUser>> ALL=(ALL) NOPASSWD: /bin/chown, /bin/chmod
```


```bash
## Disable APPARMOR
## Go to /etc/libvirt/qemu.conf
## Make sure u have no security driver
security_driver = "none"
sudo systemctl restart libvirtd
```

## | Debuging Tofu
```bash
TF_LOG=DEBUG tofu apply -auto-approve
```