terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.0.0"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mobilemedics"

    workspaces {
      name = "terraform-mc-do"
    }
  }
}

resource "digitalocean_volume" "minecraft" {
  region                  = var.region
  name                    = "minecraft"
  description = "Data volume for Minecraft"
  size                    = var.volume_size
  initial_filesystem_type = "ext4"
  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_droplet" "minecraft" {
  image  = "docker-20-04"
  name   = "minecraft"
  region = var.region
  size   = var.instance_size
  ssh_keys = [
    var.ssh_key
  ]
  user_data = file("./scripts/bootstrap.sh")
  volume_ids = [
    digitalocean_volume.minecraft.id
  ]
}

resource "digitalocean_project" "minecraft" {
  name        = "minecraft"
  description = "A Minecraft server powered by Terraform."
  purpose     = "Gaming Server"
  environment = "Production"
  resources = [
    digitalocean_droplet.minecraft.urn,
    digitalocean_volume.minecraft.urn
  ]
}