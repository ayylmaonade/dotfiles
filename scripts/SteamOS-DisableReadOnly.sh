#!/bin/sh

echo "Must be run as root!"
echo "This will disable the read-only file system"

while true do
    read -p "Would you like to install htop & neofetch?
      case $yn in
      [Yy]* ) break;;
      [Nn]* ) break;;
      * ) echo "Please type y or n";;
  esac
done

echo "Disabling read-only file system... " && sleep 1s echo "...Done!"
    sudo steamos-readonly disable

# Initiate the pacman keyring
echo "Initialising pacman keyring and appending keys from archlinux.org... "
    pacman-key --init && pacman-key --populate 
    sudo pacman -Sy archlinux-keyring

    echo "Keyring initialised & populated! Now installing htop and neofetch..." && sleep 2s

# Grabbing pkgs from arch repos
    sudo pacman -S htop neofetch

echo "Installation complete!"
