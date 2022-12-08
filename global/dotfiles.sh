#!/bin/bash

setup_alacritty_dotfile() {
    echo "Configuring Alacritty..."
    config_dir="$HOME/.config/alacritty/"
    mkdir -p "$config_dir"
    wget https://raw.githubusercontent.com/DanikingRD/dotfiles/main/user/.config/alacritty.yml
	mv alacritty.yml "$config_dir"
}


setup_alacritty_dotfile
