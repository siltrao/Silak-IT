resource "proxmox_virtual_environment_vm" "vm_test" {

  name      = "vm-test-terraform"
  node_name = var.target_node

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
