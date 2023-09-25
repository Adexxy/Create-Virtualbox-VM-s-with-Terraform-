terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

provider "virtualbox" {
  # Configuration options for the VirtualBox provider (if needed)
}

resource "virtualbox_vm" "node" {
  count = var.num_instances

  name      = "${var.instance_name_prefix}-${count.index + 1}"
  image     = var.image_location
  cpus      = var.vm_cpus
  memory    = "2048 MiB"
    
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet1"
  }
  

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ~/testfolder",
      "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd",
      # "sudo mkdir -p ~/.ssh",
    ]

    connection {
      host        = self.network_adapter[0].ipv4_address
      user        = var.user
      private_key = file(var.vagrant_ssh_key)
      type        = "ssh"
      agent       = false
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
      sshpass -p "${var.user_password}" ssh-copy-id -o "StrictHostKeyChecking=no" "${var.user}@${self.network_adapter[0].ipv4_address}"
    EOT

    connection {
      host        = self.network_adapter[0].ipv4_address
      user        = var.user
      private_key = file(var.vagrant_ssh_key)
      type        = "ssh"
      agent       = false
    }
  }
}

# Generate Ansible inventory file content
locals {
  ansible_inventory_content = <<-EOT
    ${join("\n", [for i, vm in virtualbox_vm.node : "${vm.name} ansible_ssh_host=${vm.network_adapter[0].ipv4_address} ip=${vm.network_adapter[0].ipv4_address} flannel_interface=eth1 kube_network_plugin=flannel kube_network_plugin_multus=False download_run_once=True download_localhost=False download_cache_dir=/home/marvel/kubespray_cache download_force_cache=False download_keep_remote_cache=False docker_rpm_keepcache=1 kubeconfig_localhost=True kubectl_localhost=True local_path_provisioner_enabled=False local_path_provisioner_claim_root=/opt/ ansible_ssh_user='vagrant' ansible_ssh_private_key_file='${var.vagrant_ssh_key}' "])}

    [etcd]
    kub-[1:3]

    [kube_control_plane]
    kub-[1:2]

    [kube-node]
    kub-[1:3]

    [k8s-cluster:children]
    kube-master
    kube-node

  EOT
}

# Create Ansible inventory file
resource "local_file" "inventory_file" {
  filename = "/home/marvel/Documents/DevOps/project-terraform/terraform-virtualbox-kubespray/kubespray/inventory.ini"
  content  = local.ansible_inventory_content
}

# Run Ansible playbook
resource "null_resource" "run_ansible" {
  triggers = {
    # Map the server names to their corresponding IDs
    for i, vm in virtualbox_vm.node : i => vm.id
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i inventory.ini -u ${var.user} -e 'variable=value' ${var.playbook} -b -vvv --private-key= ${var.vagrant_ssh_key}"
    working_dir = path.module

    connection {
      host        = element([for vm in virtualbox_vm.node : vm.network_adapter[0].ipv4_address], 0) # Access the first IP address
      user        = var.user
      private_key = file(var.vagrant_ssh_key)
      type        = "ssh"
      agent       = false
    }
  }

  depends_on = [local_file.inventory_file]
  
  
}

output "IPAddresses" {
  value = [for vm in virtualbox_vm.node : vm.network_adapter[0].ipv4_address]
}
