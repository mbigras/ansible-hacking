# Ansible Hacking

> Various setups to practice using Ansible

## Generate ssh key

```
ssh-keygen -q -b 2048 -t rsa -f id_rsa -N '' -C ''
```

## Vagrant usage example

```
vagrant up
vagrant provision
vagrant provision
vagrant ssh -c 'ls /home/vagrant'
vagrant destroy -f
```

## Docker usage example

```
docker build --tag mbigras/hacking .
docker run -itd --name hacking mbigras/hacking
ansible-playbook -i hacking, -c docker playbook.yml
ansible-playbook -i hacking, -c docker playbook.yml
docker exec hacking ls /somefile
docker rm -f hacking
docker rmi mbigras/hacking
```

## Terraform usage example

```
rm -f id_rsa*
ssh-keygen -q -b 2048 -t rsa -N '' -f id_rsa
export TF_VAR_do_token="$(lpass show --notes do_token)"
terraform init
terraform plan
terraform apply -auto-approve
ansible-playbook playbook.yml
ansible-playbook playbook.yml
ip=$(terraform state show digitalocean_droplet.web | awk '/ipv4_address/ { print $NF }')
ssh -i id_rsa root@$ip ls
terraform destroy -force
```

Extract DigitalOcean token using Docker if lpass isn't installed

https://github.com/mbigras/docker-lastpass-cli

```
read -p 'Email: ' email
docker run --rm -itd --name tmp mbigras/lastpass-cli
docker exec -it tmp lpass login $email
export TF_VAR_do_token="$(docker exec tmp lpass show --notes do_token)"
docker rm -f tmp
```