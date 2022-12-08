#!/usr/bin/env bash
# Install and setup distro script
distro=$(grep NAME /etc/os-release | cut -d'=' -f2 | head -1 | sed 's/["]//g' | cut -d' ' -f1)
DIR="$HOME/Projects"
[ -d $DIR ] && echo "Directory Exists" || mkdir -p $DIR; echo -e "Projects folder was created\n" && cd $DIR

################################## PERSONAL ####################################
# clone my main repositories
clone_repos() {
echo -e "Cloning repositories...\n"
git clone https://github.com/notsuitablegroup/mysub-app.git flutter
git clone https://github.com/DanikingRD/WK.git java
git clone https://github.com/DanikingRD/OpenGL-Setup.git c++
}

############################## FEDORA FUNCTIONS ################################
# extra repositories
fedora_repos() {
	sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

# system update
fedora_up() {
	sudo dnf update -y
}

# dependencies
fedora_tools() {
	sudo dnf install -y \
	wget \
	curl \
	unzip \
	gnome-tweaks \
	flatpak
}

# git and github-cli
fedora_git() {
[ -x $(command -v git) ] && gitins="true" || gitins="false"
[ -x $(command -v gh) ] && ghins="true" || ghins="false"
if [[ $gitins = "false" && $ghins = "false" ]]; then
	echo -e "Installing git and github-cli\n"
	sudo dnf install -y git gh
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
	echo -e "Please authenticate to your account in github-cli\n"
	gh auth login
elif [[ $gitins = "false" && $ghins = "true" ]]; then
	echo -e "Installing git\n"
	sudo dnf install -y git
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "true" && $ghins = "false" ]]; then
	echo -e "Installing github-cli\n"
	sudo dnf install -y gh
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
	echo -e "Please authenticate to your account in github-cli\n"
	gh auth login
elif [[ $gitins = "true" && $ghins = "true" && $gitcfg = "true" ]]; then
	echo -e "Skipping git and github-cli install...\n"
fi
}

# vs codium
fedora_codium() {
echo -e "Installing VS Codium...\n"
sudo echo \
"[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h" \
	| sudo tee -a /etc/yum.repos.d/vscodium.repo > /dev/null
	sudo dnf check-update
	sudo dnf install -y codium
}

# dev tools
fedora_dev() {
echo -e "Installing Development tools...\n"
	sudo dnf install -y \
	rust\
	cargo \
	kernel-devel \
	cmake \
	g++ \
	llvm \
	python-isort \
	python-nose \
	python-pipenv \
	python-pytest \
	gcc \
	clang \
	glslang \
	ShellCheck \
	sbcl
}

# emacs
fedora_emacs() {
[[ "$(read -e -p 'Do yo want to install doom emacs? [y/N]> '; echo $REPLY)" == [Yy]* ]] && echo -e "Installing Doom Emacs...\n"; doomwanted="yes" || doomwanted="no"
if [ $doomwanted = "yes" ]; then
	sudo dnf install -y emacs
	git clone --depth=1 https://github.com/doomemacs/doomemacs.git ~/.emacs.d/
	~/.emacs.d/bin/doom install
else
	echo -e "Skipping...\n"
fi
}

# alacritty
fedora_alacritty() {
sudo dnf install -y alacritty
	mkdir -p "$HOME/.local/share/fonts"
	mkdir -p "$HOME/.config/alacritty"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip
		unzip Mononoki.zip
		cd Mononoki
		mv mononoki* "$HOME/.local/share/fonts/"
		cd ../
		rm Mononoki*
	wget https://raw.githubusercontent.com/DanikingRD/dotfiles/main/user/.config/alacritty.yml
		mv alacritty.yml "$HOME/.config/alacritty"
}

# codecs
fedora_codecs() {
echo -e "Installing multimedia codecs...\n"
	sudo dnf install -y \
	ffmpeg \
	ffmpeg-libs \
	gstreamer1-plugins-{bad-\*,good-\*,base} \
	gstreamer1-plugin-openh264 \
	gstreamer1-libav \
	--exclude=gstreamer1-plugins-bad-free-devel
}

############################## DEBIAN FUNCTIONS ################################
# extra repos
deb_repos() {
	sudo apt install -y software-properties-common
	sudo apt-add-repository non-free
	sudo apt-add-repository contrib
	sudo echo -e "deb http://www.deb-multimedia.org bullseye main non-free" >> /etc/apt/sources.list
	sudo apt update --allow-insecure-repositories
	sudo apt install -y deb-multimedia-keyring
}

# system upgrade
deb_up() {
	sudo apt update && sudo apt upgrade
}

# dependencies
deb_tools() {
	sudo apt install \
	wget \
	curl \
	unzip \
	flatpak
}

# git and github-cli
deb_git() {
[ -x $(command -v git) ] && gitins="true" || gitins="false"
[ -x $(command -v gh) ] && ghins="true" || ghins="false"
if [[ $gitins = "false" && $ghins = "false" ]]; then
	echo -e "Installing git and github-cli\n"
	sudo apt install -y git gitsome
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "false" && $ghins = "true" ]]; then
	echo -e "Installing git\n"
	sudo apt install -y git
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "true" && $ghins = "false" ]]; then
	echo -e "Installing github-cli\n"
	sudo apt install -y gitsome
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "true" && $ghins = "true" && $gitcfg = "true" ]]; then
	echo -e "Skipping git and github-cli install...\n"
}

# vs codium
deb_codium() {
echo -e "Installing VS Codium...\n"
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
		| gpg --dearmor \
		| sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
	echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
		| sudo tee /etc/apt/sources.list.d/vscodium.list
	sudo apt update
	sudo apt install -y codium
}

# dev tools
deb_dev() {
echo -e "Installing Development tools...\n"
	sudo apt install -y \
	rust \
	cargo \
	build-essential \
	cmake \
	g++ \
	gcc \
	llvm \
	python-isort \
	python-nose \
	python-pipenv \
	python-pytest \
	clang \
	glslang \
	shellcheck \
	tidy \
	sbcl
}

# emacs
deb_emacs() {
[[ "$(read -e -p 'Do yo want to install doom emacs? [y/N]> '; echo $REPLY)" == [Yy]* ]] && echo -e "Installing Doom Emacs...\n"; doomwanted="yes" || doomwanted="no"
if [ $doomwanted = "yes" ]; then
	sudo apt install -y emacs
	git clone --depth=1 https://github.com/doomemacs/doomemacs.git ~/.emacs.d/
	~/.emacs.d/bin/doom install
else
	echo -e "Skipping...\n"
fi
}

# alacritty
deb_alacritty() {
sudo apt install -y alacritty
	mkdir -p "$HOME/.local/share/fonts"
	mkdir -p "$HOME/.config/alacritty"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip
		unzip Mononoki.zip
		cd Mononoki
		mv mononoki* "$HOME/.local/share/fonts/"
		cd ../
		rm Mononoki*
	wget https://raw.githubusercontent.com/DanikingRD/dotfiles/main/user/.config/alacritty.yml
		mv alacritty.yml "$HOME/.config/alacritty"
}

# codecs
deb_codecs() {
echo -e "Installing multimedia codecs...\n"
	sudo apt install -y\
	libavcodec-extra \
	gstreamer1.0-vaapi \
	gstreamer1.0-plugins-* \
	gstreamer1.0-alsa \
	gstreamer1.0-libav
}

############################## ARCH FUNCTIONS ##################################
# extra repos
arch_repos() {
	sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key FBA220DFC880C036
	sudo pacman -U --noconfirm\
	'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
	'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	echo "[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" \
	| sudo tee -a /etc/pacman.conf > /dev/null
}

# system upgrade
arch_up() {
	sudo pacman -Syyu --noconfirm
}

# dependencies
arch_tools() {
	sudo pacman -S --needed --noconfirm \
	wget \
	curl \
	unzip \
	flatpak
}

# git and github-cli
arch_git() {
[ -x $(command -v git) ] && gitins="true" || gitins="false"
[ -x $(command -v gh) ] && ghins="true" || ghins="false"
if [[ $gitins = "false" && $ghins = "false" ]]; then
	echo -e "Installing git and github-cli\n"
	sudo pacman -S --needed --noconfirm git github-cli
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "false" && $ghins = "true" ]]; then
	echo -e "Installing git\n"
	sudo pacman -S --needed --noconfirm git
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "true" && $ghins = "false" ]]; then
	echo -e "Installing github-cli\n"
	sudo pacman -S --needed --noconfirm github-cli
	git config --global user.name "DanikingRD"
	git config --global user.email "danikingrd@gmail.com"
elif [[ $gitins = "true" && $ghins = "true" && $gitcfg = "true" ]]; then
	echo -e "Skipping git and github-cli install...\n"
}

# vs codium
arch_codium() {
echo -e "Installing VS Codium...\n"
	sudo pacman -S --needed --noconfirm base-devel git
	git clone --depth=1 https://aur.archlinux.org/packages/vscodium-bin
	cd vscodium-bin
	makepkg -si
	cd ../
	rm -r vscodium-bin
}

# dev tools
arch_dev() {
echo -e "Installing Development tools...\n"
	sudo pacman -S --needed --noconfirm \
	base-devel \
	rust \
	cargo \
	cmake \
	gcc \
	llvm \
	python-isort \
	python-nose \
	python-pipenv \
	python-pytest \
	clang \
	glslang \
	shellcheck \
	tidy \
	sbcl
}

# emacs
arch_emacs() {
[[ "$(read -e -p 'Do yo want to install doom emacs? [y/N]> '; echo $REPLY)" == [Yy]* ]] && echo -e "Installing Doom Emacs...\n"; doomwanted="yes" || doomwanted="no"
if [ $doomwanted = "yes" ]; then
	sudo pacman -S --needed --noconfirm emacs
	git clone --depth=1 https://github.com/doomemacs/doomemacs.git ~/.emacs.d/
	~/.emacs.d/bin/doom install
else
	echo -e "Skipping...\n"
fi
}

# alacritty
arch_alacritty() {
sudo pacman -S --needed --noconfirm alacritty
	mkdir -p "$HOME/.local/share/fonts"
	mkdir -p "$HOME/.config/alacritty"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Mononoki.zip
		unzip Mononoki.zip
		cd Mononoki
		mv mononoki* "$HOME/.local/share/fonts/"
		cd ../
		rm Mononoki*
	wget https://raw.githubusercontent.com/DanikingRD/dotfiles/main/user/.config/alacritty.yml
		mv alacritty.yml "$HOME/.config/alacritty"
}

# codecs
arch_codecs() {
echo -e "Installing multimedia codecs...\n"
	sudo pacman -S --needed --noconfirm \
	gstreamer \
	gst-plugins-bad \
	gst-plugins-base \
	gst-plugins-base-libs \
	gst-plugins-good \
	gst-plugins-ugly
}

#################################### CASE ######################################
case "${distro}" in
	$"Fedora"*)
		fedora_repos
		fedora_up
		fedora_tools
		fedora_git
			clone_repos
		fedora_codium
		fedora_dev
		fedora_emacs
		fedora_alacritty
		fedora_codecs
		;;
	$"Debian"*)
		deb_repos
		deb_up
		deb_tools
		deb_git
			clone_repos
		deb_codium
		deb_dev
		deb_emacs
		deb_alacritty
		deb_codecs
		;;
	$"Arch"*)
		arch_repos
		arch_up
		arch_tools
		arch_git
			clone_repos
		arch_codium
		arch_dev
		arch_emacs
		arch_alacritty
		arch_codecs
		;;
esac

echo "Done! Press any key to Finish..."
read
