#!/bin/sh

echo "Must be run as root!"
echo "This will disable the read-only file system"

while true do
    read -p "Would you like to install htop & neofetch?
      case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please type y or n";;
  esac
done

echo "Disabling read-only file system... " && sleep 1s echo "...Done!"
    sudo steamos-readonly disable

# Initiate the pacman keyring
echo "Initialising pacman keyring and appending keys from archlinux.org... "
    pacman-key --init && pacman-key --populate && sleep 3s
    sudo pacman -Sy archlinux-keyring && sleep 3s

    echo "Keyring initialised & populated! Now installing htop and neofetch..." && sleep 2s

# Grabbing pkgs from arch repos
    sudo pacman -S htop neofetch && sleep 3s

echo "Installation complete!"
