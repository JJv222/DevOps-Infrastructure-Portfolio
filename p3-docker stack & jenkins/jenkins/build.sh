echo "=== Building Jenkins Controller image ==="
docker build -t jenkins-custom:latest /vagrant/jenkins/controller
echo "=== Building Jenkins Agent image ==="
docker build -t jenkins-agent:latest /vagrant/jenkins/agent