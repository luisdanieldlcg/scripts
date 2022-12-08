#!/bin/bash

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

install_rust() {
    if prompt "Rust"; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}
install_flutter() {
    if prompt "Dart & Flutter"; then
        echo ""
        # TODO: fetch flutter sdk & configure environment variables
    fi
}

install_rust
install_flutter
