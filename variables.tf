variable "server_names" {
  type    = list(string)
  default = ["master1","master2","worker"]
}

variable "public_key_location" {
  description = "public key location"
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_private" {
  description = "private key location"
  default = "~/.ssh/id_rsa"
}

variable "image_location" {
  description = "virtualbox image location - can be downloaded or remote location"
  default = "~/bionic-server-cloudimg-amd64-vagrant.box"
}

variable "vagrant_ssh_key" {
  description = "default vagrant ssh key location - not secure"
  default = "~/.vagrant.d/insecure_private_key"
}

variable "user" {
  description = "user to use the vm"
  default = "vagrant"
}

variable "user_password" {
  description = "user password to use the vm"
  default = "vagrant"
}

# variable "network_adapter_type" {
#   description = "network adapter type, others are NAT, NAT network, Bridged, internal network etc"
#   default = "bridged"
# }

variable "hostonly_ipv4_subnet" {
  description = "The private IPv4 subnet of the VirtualBox hostonly network (default is 192.168.56.0/16)"
  type        = string
  default     = "192.168.59.0/16"

  validation {
    condition     = can(cidrnetmask(var.hostonly_ipv4_subnet)) && split("/", var.hostonly_ipv4_subnet)[1] == "16"
    error_message = "The specified hostonly IPv4 CIDR is invalid."
  }
}

variable "internet_gateway" {
  description = "internet network gateway"
  default = "nat"
}

### varaition added from here

variable "instance_name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "kub"
}

variable "vm_cpus" {
  description = "Number of CPUs for VM instances"
  type        = number
  default     = 2
}

variable "num_instances" {
  description = "Number of VM instances to create"
  type        = number
  default     = 3
}

variable "etcd_instances" {
  description = "Number of etcd instances"
  type        = number
  default     = 3
}

variable "kube_master_instances" {
  description = "Number of kube master instances"
  type        = number
  default     = 2
}

variable "kube_node_instances" {
  description = "Number of kube node instances"
  type        = number
  default     = 3
}

variable "kube_node_instances_with_disks" {
  description = "Whether to create kube node instances with disks"
  type        = bool
  default     = false
}

variable "kube_node_instances_with_disks_size" {
  description = "Size of kube node instance disks"
  type        = string
  default     = "20G"
}

variable "kube_node_instances_with_disks_number" {
  description = "Number of kube node instance disks"
  type        = number
  default     = 2
}

variable "override_disk_size" {
  description = "Whether to override disk size"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Disk size for VM instances"
  type        = string
  default     = "20GB"
}

variable "local_path_provisioner_enabled" {
  description = "Enable local path provisioner"
  type        = bool
  default     = false
}

variable "local_path_provisioner_claim_root" {
  description = "Local path provisioner claim root directory"
  type        = string
  default     = "/opt/local-path-provisioner/"
}

variable "libvirt_nested" {
  description = "Enable libvirt nested virtualization"
  type        = bool
  default     = false
}

variable "ansible_verbosity" {
  description = "Ansible verbosity level"
  type        = string
  default     = false
}

variable "ansible_tags" {
  description = "Ansible tags"
  type        = string
  default     = ""
}

variable "playbook" {
  description = "Name of the Ansible playbook to execute"
  type        = string
  default     = "cluster.yml"
}
