#!/bin/bash

# Fedora configuration setup script file

# Installs RPM Fusion repositories. It provides
# addons packages for Fedora Linux
add_rpm_repositories() {
    echo "Adding rpm fusion repositories"
    sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora).noarch.rpm" \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora).noarch.rpm"
}

update_system() {
   sudo dnf update -y
}
# This function will install the recommended media codecs
# for Fedora Linux.
install_codecs() {
    echo -e "Installing multimedia codecs...\n"
    sudo dnf install -y --allowerasing ffmpeg
}

install_essential() {
    # Enable COPR repo
    sudo dnf copr enable varlad/helix
    sudo dnf install alacritty helix gh
    configure_github
    install_fonts
}

install_fonts() {
    echo "Installing Iosevka Term font..."
    sudo dnf copr enable peterwu/iosevka
    sudo dnf install iosevka-term-fonts
}

configure_github() {
   echo "Configuring github account"
   gh auth login
}

apply_custom_gnome_tweaks() {
    echo "Aplying custom gnome tweaks..."
    sudo dnf install gnome-tweaks gnome-extensions-app
    dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,close'"
    sudo dnf -y copr enable dirkdavidis/papirus-icon-theme
    sudo dnf -y install papirus-icon-theme
    dconf write /org/gnome/desktop/interface/icon-theme "'Papirus'"
}

add_rpm_repositories
install_codecs

read -p "Do you want to apply custom gnome tweaks (e.g install papirus theme) (Y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    apply_custom_gnome_tweaks
fi

update_system
install_essential
