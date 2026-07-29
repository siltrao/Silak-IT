resource "proxmox_virtual_environment_vm" "vm_web" {

  name      = "vm-web"
  vm_id     = 120
  node_name = var.target_node

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  agent {
    enabled = true
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 20
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
        address = "192.168.20.10/24"
        gateway = "192.168.20.1"
      }
    }
  }
}
