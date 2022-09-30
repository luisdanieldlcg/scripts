#! /bin/bash

# Enable Free and Non free repository
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Projects folder directory
DIR=~/Projects/
cd $DIR

# Checks if the given command is available on the system
command_exists() {
    if ! [ -x "$(command -v $1)" ]; then
        echo $1 'is not yet installed.' >&2
        return 1
    fi
        return 0
}

# Clones a repository in the given folder
# Parameter List
# 1.Directory 2.Url
clone_repository() {
    if ! [ -d $1 ]; then
        mkdir $1
    fi
    cd $1
    git clone $2
    cd ..
}
# Lookup my Workspace
if [ -d $DIR ]
then
    echo "Directory Exists"
else
    mkdir $DIR
    echo "Projects Folder was created"
fi

# Check if git is installed
# Install it otherwise
if ! command_exists "git"
then
    echo "Installing git..."
    sudo dnf install git
fi
echo "Configuring git..."
git config --global user.name "DanikingRD"
git config --global user.email "danikingrd@gmail.com"

# Check if github cli is installed
# Install it otherwise
if ! command_exists "gh"
then
    echo "Installing github cli..."
    sudo dnf install gh
    echo "Please authenticate to your account"
    gh auth login
fi

# Go to workspace folder
cd $DIR

# Clone my main repositories
clone_repository "flutter" "https://github.com/notsuitablegroup/mysub-app.git"
clone_repository "java" "https://github.com/DanikingRD/WK.git"
clone_repository "c++" "https://github.com/DanikingRD/OpenGL-Setup.git"

# Install VScode
echo "Installing VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code

# Install Rust
echo "Installing Rust tools..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Configuring path..."
source "$HOME/.cargo/env"

# Install Doom Emacs
echo "Installing Doom Emacs..."
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
# export PATH="$HOME/.emacs.d/bin:$PATH"

# Install Alacritty
sudo dnf install alacritty

# Fix fedora not playing some youtube videos
sudo dnf install ffmpeg ffmpeg-libs

# Grab dotfiles and install it
# Current directory is ~/Projects
wget https://github.com/DanikingRD/dotfiles/archive/refs/heads/main.zip -O  dotfiles.zip
unzip dotfiles.zip
cd dotfiles-main
./run.sh


# Update system  packages
echo "Updating system..."
sudo dnf upgrade

echo "Done!"
echo "Press any Enter to finish"
read
