#!/bin/sh

# Script: SteamOS-DisableRO
# Description: Unlocks the Steam Deck file system, refreshes Arch pacman keyring, installs htop + neofetch & decky-loader
# Dependencies: A steam deck. Do not run this on 'normal' linux distros.
# License: GPLv3
# Contributors: Shaun (ayylmaonade)

# Immediately aborts script if any errors occur
set -e

echo "Must be run as root!"
echo "This will disable the read-only file system! I am not responsible for any damage caused by user error."
echo "Packages to be installed: htop, neofetch, decky-loader"

    read -p "Are you sure you'd like to continue?"
      case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please type Y/n";;
  esac

echo "Disabling read-only file system..." && sleep 1s "...Done!"
    sudo steamos-readonly disable

# Initiate the pacman keyrings
echo "Initialising pacman keyring and appending keys from archlinux.org... "
    pacman-key --init && pacman-key --populate && sleep 3s
    sudo pacman -Sy archlinux-keyring && sleep 3s

    echo "Keyring initialised & populated! Now installing htop and neofetch..." && sleep 2s

# Grabbing pkgs from arch repos
    sudo pacman -S htop neofetch && sleep 3s

    echo "Installing stable release version of decky-loader!\n
    You may have to re-enter your root password."
# Grabbing the release version of decky loader and installing it
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

    echo "All packages installed successfully! Enjoy!"

exit
