# This script installs Docker and Go on an Ubuntu system.
# It performs the following steps:
# 1. Adds Docker's official GPG key.
# 2. Adds the Docker repository to Apt sources.
# 3. Installs Docker CE, Docker CLI, containerd.io, docker-buildx-plugin, and docker-compose-plugin.
# 4. Creates a docker group and adds the current user to it.
# 5. Installs gcc and build-essential packages.
# 6. Downloads the Go binary from the specified URL.
# 7. Removes any existing Go installation.
# 8. Extracts the downloaded Go binary to /usr/local.
# 9. Updates the PATH environment variable to include the Go binary paths.
# 10. Applies changes to the current session.

# Usage: bash step_01.sh
#Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker $USER
sudo apt install gcc -y && sudo apt install build-essential -y
sudo apt  install docker-compose -y
# URL of the Go binary
GO_BINARY_URL="https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"

# Download the Go binary
wget $GO_BINARY_URL -O go.tar.gz

# Remove any existing Go installation
sudo rm -rf /usr/local/go

# Extract the downloaded Go binary to /usr/local
sudo tar -C /usr/local -xzf go.tar.gz

# Clean up the downloaded file
rm go.tar.gz

# Add Go binary paths to PATH in a more generic way
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/home/$USER/go/bin' >> ~/.bashrc

# Apply changes to current session
source ~/.bashrc

echo "Go installation and PATH update complete."

# This script installs LAZYDOCKER by downloading the latest release from GitHub and extracting it to the appropriate location.
# It uses the GitHub API to fetch the latest release version and then downloads the corresponding tar.gz file.
# The tar.gz file is then extracted to a temporary directory, and the 'lazydocker' binary is moved to /usr/local/bin.
# Finally, the temporary files are cleaned up.

echo " Installing LAZYDOCKER"
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
mkdir lazydocker-temp
tar xf lazydocker.tar.gz -C lazydocker-temp
sudo mv lazydocker-temp/lazydocker /usr/local/bin
rm -rf lazydocker.tar.gz lazydocker-temp
echo "LAZYDOCKER Installed"