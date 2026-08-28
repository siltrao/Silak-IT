resource "proxmox_virtual_environment_container" "vm_client" {
  node_name = var.target_node
  vm_id     = 160
  started   = false
  initialization {
    hostname = "vm-client"
    ip_config {
      ipv4 {
        address = "192.168.90.10/24"
        gateway = "192.168.90.1"
      }
    }
    user_account {
      keys = [
        trimspace(file("/root/.ssh/id_ed25519.pub"))
      ]
    }
  }
  network_interface {
    name    = "eth0"
    bridge  = "vmbr1"
    vlan_id = 90
  }
  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type              = "debian"
  }
  disk {
    datastore_id = "local-lvm"
    size         = 4
  }
  memory {
    dedicated = 512
  }
  cpu {
    cores = 1
  }
}
