#!/bin/bash

echo "Installing Paru"
sudo pacman -S --needed --noconfirm base-devel rustup
rustup default stable
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
sudo rm -r paru

echo "Installing dotfiles"
git clone https://github.com/luisdanieldlcg/dotfiles
mv dotfiles ~/
sh ~/dotfiles/install.sh

echo "Installing dependencies"
sudo pacman -S git \
    'less' \
    github-cli \
    ttf-fira-code \
    ttf-jetbrains-mono \
    alacritty \
    firefox \
    neovim \
    ripgrep \
    xdg-user-dirs \
    xdg-utils \
    grim \
    slurp \
    wl-clipboard \
    ttf-nerd-fonts-symbols \
    wlogout \
    pavucontrol \
    htop --noconfirm

paru -S rofi-wayland

echo "Setting up Git"
git config --global user.email "luisdanieldlcg@gmail.com"
git config --global user.name "luisdanieldlcg"
git config --global core.editor "nvim"

