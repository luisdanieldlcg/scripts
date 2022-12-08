#!/bin/bash

# This script will update your git config file

configure_git() {
    # Git comes preinstalled on Fedora Linux
    echo "Configuring Git..."
    read -r -p "Enter your Git username: " username
    git config --global user.name "$username"
    read -r -p "Enter your Git email: " email
    git config --global user.email "$email"
    echo "Printing your git config..."
    git config --list
}

configure_git
