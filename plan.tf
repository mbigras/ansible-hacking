variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
  version = "~> 0.1"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

resource "digitalocean_ssh_key" "default" {
  name = "tmp key"
  public_key = "${file("id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
  name = "somehost"
  image = "ubuntu-18-04-x64"
  region = "sfo2"
  size = "512mb"
  ssh_keys = [
    "${digitalocean_ssh_key.default.fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("id_rsa")}"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "echo Waiting for cloud-init...",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "echo Cloud-init is finished!",
      "apt-get update -y",
      "apt-get install -y python",
    ]
  }
}

resource "null_resource" "ssh_tester" {
  provisioner "local-exec" {
    command = <<EOF
      ip="${digitalocean_droplet.web.ipv4_address}"
      ssh-keyscan $ip >> ~/.ssh/known_hosts
      ssh -i id_rsa root@$ip echo Hello remote world!
      # ansible all -m ping
    EOF
  }
}

resource "local_file" "hosts" {
    content = "[droplets]\n${digitalocean_droplet.web.ipv4_address}\n"
    filename = "hosts"
}

resource "null_resource" "ansible_tester" {
  provisioner "local-exec" {
    command = <<EOF
      ansible all -m ping
    EOF
  }
  depends_on = [
    "local_file.hosts",
    "null_resource.ssh_tester"
  ]
}