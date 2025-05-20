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

# | Running commands

```bash
tofu init
tofu plan
tofu apply
``` 

# | Cloud Init


```
vm_name = "ubuntu-demo"
memory  = 2048
vcpu    = 2
```

# | Known problems

