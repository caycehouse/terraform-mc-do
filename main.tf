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

resource "digitalocean_domain" "minecraft" {
  name = var.domain
}

resource "digitalocean_record" "minecraft" {
  domain = digitalocean_domain.minecraft.name
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.minecraft.ipv4_address
  ttl = 60
}

resource "digitalocean_project" "minecraft" {
  name        = "minecraft"
  description = "A Minecraft server powered by Terraform."
  purpose     = "Gaming Server"
  environment = "Production"
  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_project_resources" "droplet" {
  project = digitalocean_project.minecraft.id
  resources = [
    digitalocean_droplet.minecraft.urn
  ]
}

resource "digitalocean_project_resources" "others" {
  project = digitalocean_project.minecraft.id
  resources = [
    digitalocean_volume.minecraft.urn,
    digitalocean_domain.minecraft.urn
  ]
}