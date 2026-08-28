resource "proxmox_virtual_environment_vm" "vm_ldap" {
  name      = "vm-ldap"
  vm_id     = 125
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
    dedicated = 1024
  }
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 10
  }
  agent {
    enabled = true
  }
  network_device {
    bridge  = "vmbr1"
    vlan_id = 10
  }
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.10.30/24"
        gateway = "192.168.10.1"
      }
    }
    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
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
