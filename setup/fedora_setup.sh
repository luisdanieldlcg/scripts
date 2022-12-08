#!/bin/bash

# Fedora configuration setup script file

# Installs RPM Fusion repositories. It provides
# addons packages for Fedora Linux
add_rpm_repositories() {
    echo "Adding rpm fusion repositories"
    sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora).noarch.rpm" \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora).noarch.rpm"
}

update_system() {
   sudo dnf update -y
}
# This function will install the recommended media codecs
# for Fedora Linux.
install_codecs() {
    echo -e "Installing multimedia codecs...\n"
    sudo dnf install -y \
    ffmpeg \
	ffmpeg-libs \
	gstreamer1-plugins-{bad-\*,good-\*,base} \
	gstreamer1-plugin-openh264 \
	gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel
}


add_rpm_repositories
update_system
configure_git
install_codecs
