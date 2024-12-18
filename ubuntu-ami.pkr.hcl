packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "commit_id" {
  type        = string
  description = "Commit ID used for tagging the AMI"
}

variable "public_key" {
  type        = string
  description = "public ssh key for distro user"
}

variable "private_key" {
  type        = string
  description = "private ssh key for distro user"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

source "amazon-ebs" "ubuntu_source" {
  region         = var.aws_region
  instance_type  = var.instance_type
  source_ami     = "ami-0dee22c13ea7a9a67"
  ssh_username   = "ubuntu"
  ami_name       = "ubuntu-ansible-ami-${var.commit_id}"
  ami_description = "An Ubuntu AMI built with Packer and configured with Ansible"
  tags = {
    Name        = "base-eks-image"
    Purpose     = "eks-node"
    Environment = "production"
    CreatedBy   = "packer"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu_source"]

  provisioner "ansible" {
    playbook_file = "ansible-base-software.yml"
    extra_arguments = [
        "--extra-vars",
        "public_key=${var.public_key} private_key=${var.private_key}"
    ]
  }
}
