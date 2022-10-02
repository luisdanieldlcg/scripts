#!/usr/bin/env bash
# check distro
os=$(grep NAME /etc/os-release | head -1 | cut -d'=' -f2 | sed 's/["]//g' | cut -d' ' -f1)

# Enable Free and Non free repository
if [ "${os}" = "Fedora" ]; then
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
else
	echo "OS is not Fedora"
fi

# Projects folder directory
DIR="$HOME/Projects"
[ -d $DIR ] && echo "Directory Exists" || mkdir -p $DIR; echo "Projects folder was created" && cd $DIR

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

# Installs git
install_git() {
if [ "${os}" = "Fedora" ]; then
	sudo dnf install git
elif [ "${os}" = "Debian" ]; then
	sudo apt install git
elif [ "${os}" = "Arch" ]; then
	sudo pacman -S --needed git
fi
}

# System Update
echo "Updating system..."
if [ "${os}" = "Fedora" ]; then
	sudo dnf update
elif [ "${os}" = "Debian" ]; then
	sudo apt update && sudo apt upgrade
elif [ "${os}" = "Arch" ]; then
	sudo pacman -Syyu
fi

# Install some tools
echo "Installing tools...\n"
if [ "${os}" = "Fedora" ]; then
	sudo dnf install wget curl unzip gnome-tweaks flatpak
elif [ "${os}" = "Debian" ]; then
	sudo apt install wget curl unzip flatpak
elif [ "${os}" = "Arch" ]; then
	sudo pacman -S --needed wget curl unzip flatpak
fi

# Configuring flatpak
echo "Installing flathub...\n"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Check if git is installed
# Install it otherwise and configure
[ -x $(command -v git) ] && echo "Git is already installed" || echo "Installing git...\n"; install_git
[ -f $HOME/.gitconfig ] && gitconfig="true" || gitconfig="false"
if [ $gitconfig = "false" ]; then
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
else
	echo "File .gitconfig exists\n"
fi

# Check if github cli is installed
# Install it otherwise
[ -x $(command -v gh) ] && ghinstall="true" || echo "Installing github-cli...\n"; ghinstall="false"
if [[ "${os}" = "Fedora" && "${ghinstall}" = "false" ]]; then
	sudo dnf install gh
	echo "Please authenticate to your account\n"
	gh auth login
elif [[ "${os}" = "Debian" && "${ghinstall}" = "false" ]]; then
	sudo apt install gitsome # not the same as github-cli but it's close enough
elif [[ "${os}" = "Arch" && "${ghinstall}" = "false" ]]; then
	sudo pacman -S --needed github-cli
	echo "Please authenticate to your account\n"
	gh auth login
fi

# Clone my main repositories
echo "Cloning repositories...\n"
clone_repository "flutter" "https://github.com/notsuitablegroup/mysub-app.git"
clone_repository "java" "https://github.com/DanikingRD/WK.git"
clone_repository "c++" "https://github.com/DanikingRD/OpenGL-Setup.git"

# Install VS Codium
if [ "${os}" = "Fedora" ]; then
	echo "Installing VS Codium...\n"
sudo echo "[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo > /dev/null
	sudo dnf check-update
	sudo dnf install codium
elif [ "${os}" = "Debian" ]; then
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
	    | gpg --dearmor \
	    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
	echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
	    | sudo tee /etc/apt/sources.list.d/vscodium.list
	sudo apt update
	sudo apt install codium
elif [ "${os}" = "Arch" ]; then
	sudo pacman -S --needed base-devel git
	git clone --depth=1 https://aur.archlinux.org/packages/vscodium-bin && cd vscodium-bin
	makepkg -si
	cd ../ && rm -r vscodium-bin
fi

# Install Rust
echo "Installing Development tools\n"
sudo dnf install rust cargo kernel-devel cmake g++ llvm python-isort python-nose python-pipenv python-pytest gcc clang glslang ShellCheck
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Configuring path..."
source "$HOME/.cargo/env"

# Install Emacs
[[ "$(read -e -p 'Do yo want to install doom emacs? [y/N]> '; echo $REPLY)" == [Yy]* ]] && doomwanted="yes" || doomwanted="no"
if [ $doomwanted = "yes" ]; then
	echo "Installing Doom Emacs...\n"
	sudo dnf install emacs
	git clone --depth=1 https://github.com/doomemacs/doomemacs.git ~/.emacs.d/
	~/.emacs.d/bin/doom install
else
	echo "Skipping...\n"
fi

# Install Alacritty
echo "Installing and configuring alacritty...\n"
if [ "${os}" = "Fedora" ]; then
	sudo dnf install alacritty
elif [ "${os}" = "Debian" ]; then
	sudo apt install alacritty
elif [ "${os}" = "Arch" ]; then
	sudo pacman -S alacritty
fi
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.config/alacritty"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip && unzip Mononoki.zip && mv mononoki* "$HOME/.local/share/fonts/" && rm Mononki.zip readme.md LICENSE.txt
wget https://raw.githubusercontent.com/DanikingRD/dotfiles/main/user/.config/alacritty.yml && mv alacritty.yml "$HOME/.config/alacritty"

# Install media libraries
echo "Installing multimedia codecs...\n"
sudo dnf install ffmpeg ffmpeg-libs gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
echo "Done!"
echo "Press any Enter to finish\n"
read
