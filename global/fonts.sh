#!/bin/bash

# This script will fetch and setup my custom fonts

FONTS_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONTS_DIR"

function fetch_fonts() {
    echo "Downloading fonts..."
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip
    wget github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip
}

function install_fonts() {
    echo "Installing fonts..."
    # Unzip all .zip files
    unzip "*.zip"
    # Move all .ttf files to the fonts directory
    find . -name "*.ttf" -exec mv {} "$FONTS_DIR" ";"
}

# Removes all the files excluding the ones with .sh extension
function clear_dir(){
    echo "Clearing directory..."
    find . -type f ! -name "*.sh" -exec rm -rf {} \;
    # This is left over
    rm -r fonts/
}

fetch_fonts
install_fonts
clear_dir
