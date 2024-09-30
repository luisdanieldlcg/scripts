#!/bin/bash

# This is a script for setting up my Fedora Linux environment after a fresh install

PROJECTS_DIR="$HOME/dev/"
SDK_DIR="$HOME/Projects/SDKs"
FONTS_DIR="$HOME/.local/share/fonts"
EXPORT_LOCATION="$HOME/.bashrc"

mkdir -p "$FONTS_DIR"
mkdir -p "$PROJECTS_DIR"

# Prompt the user whether to install a package or not 
prompt() {
    read -r -p "Press y to install $1 or any other key to skip it: " bool
    case $bool in
        y|Y )
            echo "Installing $1..."
            return 0;;
        * ) echo "$1 instalation skipped."
            return 1;;
    esac
}

# a function to create custom keybindings
# first arg: a number assigned to keybinding
# second arg: name of the keybinding
# third arg: command for the keybinding
# forth arg: the keyboard shortcut for the keybinding
# from: https://stackoverflow.com/questions/56457682/setting-up-gnome-keybindings-in-a-bash-function
function key {
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$1/" name "$2"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$1/" command "$3"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$1/" binding "$4"
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$1/']"
}

# Set my custom keybindings
# open terminal with win + enter
key 0 "Wezterm" "wezterm" "<Super>Return"
# open nautilus with win + e
key 1 "Nautilus File Manager" "nautilus" "<Super>e"


# Install the RPM Fusion repositories
# This will provide additional packages for Fedora  
echo "Adding rpm fusion repositories"
sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora).noarch.rpm" \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora).noarch.rpm"

# Update the system
sudo dnf update -y

# Install essential packages 
echo -e "Installing multimedia codecs...\n"
sudo dnf install -y --allowerasing ffmpeg
sudo dnf install -y https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203_110809_5046fc22-1.fedora39.x86_64.rpm
sudo dnf install -y gh

# Configure git & github
# Git comes preinstalled on Fedora Linux
echo "Configuring Git..."
read -r -p "Enter your Git username: " username
git config --global user.name "$username"
read -r -p "Enter your Git email: " email
git config --global user.email "$email"
echo "Printing your git config..."
git config --list

echo "Configuring github account"
gh auth login

# Install fonts
echo "Installing fonts..."
sudo dnf copr enable peterwu/iosevka
sudo dnf install iosevka-term-fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip
wget github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip
# Unzip all .zip files
unzip "*.zip"
# Move all .ttf files to the fonts directory
find . -name "*.ttf" -exec mv {} "$FONTS_DIR" ";"
echo "Clearing directory..."
find . -type f ! -name "*.sh" -exec rm -rf {} \;
# This is left over
rm -r fonts/

# Install some flatpak packages I use
flatpak install -y flathub com.discordapp.Discord \
	org.videolan.VLC \
	com.obsproject.Studio \
	org.signal.Signal \

# Install development tools
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "export PATH=$HOME/.cargo/bin:$PATH" >> "$EXPORT_LOCATION"
source "$HOME/.cargo/env"

if prompt "Dart & Flutter"; then
    src="$SDK_DIR/flutter"
    mkdir "$src"
    git clone https://github.com/flutter/flutter.git -b stable "$src"
    echo "export PATH=$PATH:$SDK_DIR/flutter/bin" >> "$EXPORT_LOCATION"
    flutter
fi

if prompt "Android Studio"; then
    flatpak install -y flathub com.google.AndroidStudio
fi

if prompt "Visual Studio Code" ; then
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	dnf check-update
	sudo dnf install code # or code-insiders
fi

# 8) Install my dotfiles
cd
git clone https://github.com/luisdanieldlcg/dotfiles
cd dotfiles/
chmod +x install.sh
sh install.sh

echo "Done! Press any key to exit."
read