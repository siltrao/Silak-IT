variable "proxmox_api_url" {
  type = string
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "target_node" {
  type = string
}

variable "template_id" {
  type = number
}
