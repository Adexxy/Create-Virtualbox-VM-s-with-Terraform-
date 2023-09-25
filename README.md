# Terraform-Virtualbox-Ansible

This repository contains Terraform code to provision VMs using VirtualBox and an Ansible playbook to deploy an application to the VMs.

Getting started

To use this repository, you will need to install Terraform and VirtualBox.

Once you have installed Terraform and VirtualBox, you can clone this repository:

```sh
git clone https://github.com/Adexxy/Create-Virtualbox-VM-s-with-Terraform-.git

```

Navigate to the repository directory:

```sh
cd Create-Virtualbox-VM-s-with-Terraform-.git
```

Initialize the Terraform backend:

```sh
terraform init
```

Plan the infrastructure changes:

```sh
terraform plan
```

Apply the infrastructure changes:

```sh
terraform apply
```

This will create new VM's in VirtualBox.

Deploying the application

To deploy the application to the VM, you will need to create an Ansible playbook. The playbook should contain the following steps:

1. Install the required packages on the VM.
2. Deploy the application to the VM.
3. Start the application.

Once you have created the Ansible playbook, you can deploy it to the VM using the following command by adding your playbook here: 

```sh
provisioner "local-exec" {
    command     = "ansible-playbook -i inventory.ini -u ${var.user} -e 'variable=value' ${var.playbook} -b -vvv --private-key= ${var.vagrant_ssh_key}"
    working_dir = path.module
```

This will deploy the application to the VM and start it.

Troubleshooting

If you have any problems provisioning the VM or deploying the application, please consult the Terraform and Ansible documentation.
