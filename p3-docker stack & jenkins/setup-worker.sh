#!/bin/bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "insecure-registries": ["192.168.56.200:5000"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

until [ -f /vagrant/join-token-worker.txt ]
do
    sleep 5
done

echo ">>> Configuring SSH access for Jenkins..."
mkdir -p /home/vagrant/.ssh

if [ -f /vagrant/jenkins/secrets/ssh_worker1_key.pub ]; then
    cat /vagrant/jenkins/secrets/ssh_worker1_key.pub >> /home/vagrant/.ssh/authorized_keys
    echo ">>> SSH Public Key added."
else
    echo ">>> WARNING: SSH Public Key not found!"
fi

chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys

chown -R vagrant:vagrant /home/vagrant/.ssh

#java 21
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
sudo dpkg -i jdk-21_linux-x64_bin.deb
#workspace
sudo mkdir /workspace
sudo chown -R vagrant:vagrant /workspace
chmod 755 /workspace

docker swarm join --token "`cat /vagrant/join-token-worker.txt`"  192.168.56.200:2377