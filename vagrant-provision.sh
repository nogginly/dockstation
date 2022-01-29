
ARG_DOCKER_PORT=$1

# ------ start of steps from https://docs.docker.com/engine/install/ubuntu/

# Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
# It’s OK if apt-get reports that none of these packages are installed.
apt-get remove docker docker-engine docker.io containerd runc

# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Use the following command to set up the stable repository.
# To add the nightly or test repository, add the word `nightly` or `test` (or both) after the word `stable` in the commands below
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index, and install the latest version of Docker Engine and containerd
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# ------- end of steps from https://docs.docker.com/engine/install/ubuntu/

# Configure Docker to listen on a TCP socket
mkdir -p /etc/systemd/system/docker.service.d

echo \
'[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock' | tee /etc/systemd/system/docker.service.d/docker.conf > /dev/null

echo \
"{
  \"hosts\": [\"fd://\", \"tcp://0.0.0.0:$ARG_DOCKER_PORT\"]
}" | tee /etc/docker/daemon.json > /dev/null

systemctl daemon-reload
systemctl restart docker.service
