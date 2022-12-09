#!/bin/bash

# This script installs some common flatpak packages

install_flatpak_packages() {
    echo "Installing Flatpak packages..."
    flatpak install -y flathub com.discordapp.Discord org.videolan.VLC
    flatpak update
    echo -e "Installed flatpak packages: \n"
    flatpak list
    echo -e "\n"
}


install_flatpak_packages
