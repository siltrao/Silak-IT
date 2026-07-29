resource "proxmox_virtual_environment_vm" "vm_router" {

  name      = "vm-router"
  vm_id     = 105
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

  # =========================
  # INTERFACE 1 : WAN (Internet)
  # =========================
  network_device {
    bridge = "vmbr0"
  }

  # =========================
  # INTERFACE 2 : TRUNK VLAN
  # =========================
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

    # IP = DHCP sur WAN (ou static si tu veux)
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
