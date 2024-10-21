#!/bin/bash

echo "Installing dotfiles"
git clone https://github.com/luisdanieldlcg/dotfiles
mv dotfiles ~/
sh ~/dotfiles/install.sh

echo "Installing dependencies"
sudo pacman -S hyprland \
    waybar \
    xdg-user-dirs \
    xdg-utils \
    git \
    less \
    github-cli \
    ttf-fira-code \
    alacritty \
    firefox \
    neovim --noconfirm

echo "Setting us  directories"
xdg-user-dirs-update

echo "Setting up Git"
git config --global user.email "luisdanieldlcg@gmail.com"
git config --global user.name "luisdanieldlcg"

echo "Authenticating with github"
gh auth login
