#!/bin/bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "insecure-registries": ["192.168.56.200:5000"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
# Setup Docker Swarm Manager Node firewall exception
iptables -A INPUT -p tcp --dport 2377 -j ACCEPT
iptables -A INPUT -p tcp --dport 9443 -j ACCEPT
netfilter-persistent save

echo ">>> Configuring SSH access for Jenkins..."
mkdir -p /home/vagrant/.ssh

if [ -f /vagrant/jenkins/secrets/ssh_manager_key.pub ]; then
    cat /vagrant/jenkins/secrets/ssh_manager_key.pub >> /home/vagrant/.ssh/authorized_keys
    echo ">>> SSH Public Key added."
else
    echo ">>> WARNING: SSH Public Key not found!"
fi

chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys

chown -R vagrant:vagrant /home/vagrant/.ssh


# Initialize Docker Swarm
if ! docker info | grep -q "Swarm: active"; then
    docker swarm init --advertise-addr 192.168.56.200
else
    echo "Swarm już działa, pomijam init."
fi

# Zamiast gołego docker service create:
if ! docker service ls | grep -q "registry"; then
    docker service create --name registry --publish 5000:5000 registry:2
else
    echo "Usługa registry już istnieje."
fi
# Save join tokens to files for worker nodes
docker swarm join-token worker --quiet > /vagrant/join-token-worker.txt

# Deploy Portainer app for managing the Swarm
docker image pull portainer/portainer-ce:lts --quiet
docker image pull portainer/agent:lts --quiet
bash /vagrant/jenkins/build.sh
docker stack deploy -c /vagrant/portainer-agent-stack.yml portainer