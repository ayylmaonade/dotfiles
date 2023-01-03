#!/bin/bash

echo "Must be run as root!"
echo "This will disable the read-only file system"

while true do
    read -p "Would you like to install htop & neofetch?
      case $yn in
      [Yy]* ) break;;
      [Nn]* ) break;;
      * ) echo "Please type y or n";;
esdac
done

echo "Installing packages...

# Grabbing pkgs from arch repos
sudo pacman -S htop neofetch

echo "instllation complete1"
