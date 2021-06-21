variable "region" {
  description = "The region to deploy this infrastructure in"
}
variable "instance_size" {
  description = "The instance type to use (https://developers.digitalocean.com/documentation/v2/#list-all-sizes)"
}
variable "ssh_key" {
  description = "The SSH Key ID or fingerprint to use"
}
variable "volume_size" {
  description = "The size in GB of the Minecraft data volume"
}
variable "domain" {
  description = "The domain name to update"
}
variable "your_ipv4" {
  description = "Your IPv4 address in cidr notation"
  default = "192.168.1.0/24"
}