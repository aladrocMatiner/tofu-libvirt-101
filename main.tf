########
## Providers
######

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.14"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

########
## Resources
######

resource "libvirt_volume" "ubuntu-qcow2" {
  name = "ubuntu22.qcow2"
  pool = "default"
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  format = "qcow2"

  provisioner "local-exec" {
    command = "sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/ubuntu22.qcow2 && sudo chmod 660 /var/lib/libvirt/images/ubuntu22.qcow2"
  }
}

resource "libvirt_domain" "ubuntu_vm" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpu

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}

########
## Cloud Init
######
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = "default"

  provisioner "local-exec" {
    command = "sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/cloudinit.iso && sudo chmod 660 /var/lib/libvirt/images/cloudinit.iso"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init/user-data.yaml")
}

data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/network-config.yaml")
}

########
## Ansible Inventory
######
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = <<EOF
[ubuntu]
${libvirt_domain.ubuntu_vm.network_interface.0.addresses[0]} ansible_user=aladroc ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF
}
