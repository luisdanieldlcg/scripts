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
    github-cli \
    ttf-fira-code \
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
    pavucontrol
    less --noconfirm

paru -S rofi-wayland

echo "Setting up Git"
git config --global user.email "luisdanieldlcg@gmail.com"
git config --global user.name "luisdanieldlcg"

echo "Authenticating with github"
gh auth login

