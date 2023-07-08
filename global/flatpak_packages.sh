#!/bin/bash

# This script installs some common flatpak packages

EXPORT_LOCATION="$HOME/.bashrc"
# Detach a process from the terminal
DETACH="command & disown"

install_flatpak_packages() {
    echo "Installing Flatpak packages..."
    flatpak install -y flathub com.discordapp.Discord \
            org.videolan.VLC \
            org.telegram.desktop \
            com.helix_editor.Helix \
            com.obsproject.Studio \
            org.signal.Signal \
            com.brave.Browser

    create_aliases
    prompt_other_devtools
    flatpak update
    echo -e "Installed flatpak packages: \n"
    flatpak list
    echo -e "\n"
}

create_aliases() {
    echo "Creating aliases..."
    echo -e >> "$EXPORT_LOCATION" # Add a new line
    echo "# Flatpak aliases" >> "$EXPORT_LOCATION"
    echo "alias discord='flatpak run com.discordapp.Discord'" >> "$EXPORT_LOCATION"
    echo "alias vlc='flatpak run org.videolan.VLC'" >> "$EXPORT_LOCATION"
    echo "alias helix='flatpak run com.helix_editor.Helix'; alias hx='helix'" >> "$EXPORT_LOCATION"
    echo "alias brave='flatpak run com.brave.Browser'" >> "$EXPORT_LOCATION"
    source "$HOME/.bashrc"
}

prompt_other_devtools() {
    if prompt "Intellij"; then
        flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
        echo "alias intellij='flatpak run com.jetbrains.IntelliJ-IDEA-Community'" >> "$EXPORT_LOCATION"
    fi

    if prompt "Android Studio"; then
        flatpak install -y flathub com.google.AndroidStudio
        echo "alias android-studio='flatpak run com.google.AndroidStudio'" >> "$EXPORT_LOCATION"
    fi

    if prompt "Visual Studio Code" ; then
        flatpak install -y flathub com.visualstudio.code
        echo "alias code='flatpak run com.visualstudio.code'" >> "$EXPORT_LOCATION"
    fi

    if prompt "Gimp" ; then
        flatpak install -y flathub org.gimp.GIMP
        echo "alias gimp='flatpak run org.gimp.GIMP'" >> "$EXPORT_LOCATION"
    fi
}

# TODO: this is duplicated code, find a way to reuse it
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

install_flatpak_packages
