packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    },
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_name" {
  default = "ubuntu-ansible-ami-1"
}

source "amazon-ebs" "ubuntu_source" {
  region         = var.aws_region
  instance_type  = var.instance_type
  source_ami     = "ami-0dee22c13ea7a9a67"
  ssh_username   = "ubuntu"
  ami_name       = var.ami_name
  ami_description = "An Ubuntu AMI built with Packer and configured with Ansible"
}

build {
  sources = ["source.amazon-ebs.ubuntu_source"]

  provisioner "ansible" {
    playbook_file = "../create_user_docker_java_tools_ebs.yml"
    extra_arguments = ["--ssh-extra-args", "-o StrictHostKeyChecking=no"]
  }
}
