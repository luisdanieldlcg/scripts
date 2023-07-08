#!/bin/bash
#
# This script will call all the other scripts
# related to configuration & setup.

# Constants
DISTRIBUTION=$(grep NAME /etc/os-release | cut -d'=' -f2 | head -1 | sed 's/["]//g' | cut -d' ' -f1)
PROJECTS_DIR="$HOME/dev/"
GLOBAL_DIR="./global"
SCRIPT_SETUP="./setup/${DISTRIBUTION,,}_setup.sh"

# Create my projects folder
mkdir -p "$PROJECTS_DIR"

#  Run the appropiate script for the current OS
echo "Running $DISTRIBUTION setup..."
sh "$SCRIPT_SETUP"

# Run global setup that does not relies on OS package manager
for file in "$GLOBAL_DIR"/*.sh; do
    echo "Running $file"
    sh "$file"
    echo "$file was executed successfully!"
done


function on_finish() {
    echo "Done! Press any key to exit."
    read
}

on_finish
