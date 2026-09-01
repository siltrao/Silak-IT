resource "proxmox_virtual_environment_vm" "vm_router2" {
  name      = "vm-router2"
  vm_id     = 106
  node_name = var.target_node
  clone {
    vm_id = var.template_id
  }
  cpu {
    cores = 2
  }
  memory {
    dedicated = 1024
  }
  agent {
    enabled = true
  }
  network_device {
    bridge = "vmbr0"
  }
  network_device {
    bridge = "vmbr1"
  }
  initialization {
    user_account {
      username = "debian"
      keys = [
        file("/root/.ssh/id_ed25519.pub")
      ]
    }
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
