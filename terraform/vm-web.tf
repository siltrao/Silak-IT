resource "proxmox_virtual_environment_vm" "vm_web" {
  name      = "vm-web"
  vm_id     = 120
  node_name = var.target_node
  on_boot   = false
  started   = false
  clone {
    vm_id = var.template_id
  }
  cpu {
    cores = 1
  }
  memory {
    dedicated = 512
  }
  agent {
    enabled = true
  }
  network_device {
    bridge  = "vmbr1"
    vlan_id = 20
  }
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.20.10/24"
        gateway = "192.168.20.1"
      }
    }
    user_account {
      username = "silak"
      keys = [
        trimspace(file("/root/.ssh/id_ed25519.pub"))
      ]
    }
  }
  operating_system {
    type = "l26"
  }
}
