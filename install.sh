#! /bin/bash

# Projects folder directory
DIR=~/Projects/
cd $DIR

# Checks if the given command is available on the system
command_exists() {
    if ! [ -x "$(command -v $1)" ]; then
        echo $1 'is not yet installed.' >&2
        return 1
    fi
        return 0
}

# Clones a repository in the given folder
# Parameter List
# 1.Directory 2.Url
clone_repository() {
    if ! [ -d $1 ]; then
        mkdir $1
    fi
    cd $1
    git clone $2
    cd ..
}
# Lookup my Workspace
if [ -d $DIR ]
then
    echo "Directory Exists"
else
    mkdir $DIR
    echo "Projects Folder was created"
fi

# Check if git is installed
# Install it otherwise
if ! command_exists "git"
then
    echo "Installing git..."
    sudo dnf install git
    git config --global user.name "DanikingRD"
    git config --global user.email "danikingrd@gmail.com"
fi

# Check if github cli is installed
# Install it otherwise
if ! command_exists "gh"
then
    echo "Installing github cli..."
    sudo dnf install gh
    echo "Please authenticate to your account"
    gh auth login
fi

# Go to workspace folder
cd $DIR

# Clone my main repositories
clone_repository "flutter" "https://github.com/notsuitablegroup/mysub-app.git"
clone_repository "java" "https://github.com/DanikingRD/WK.git"

echo "Done!"
echo "Press any Enter to finish"
read
