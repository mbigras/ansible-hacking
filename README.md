# Ansible Hacking

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
