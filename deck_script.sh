#!/bin/sh

echo "Run as root!"

while true; do
    read -p "This will automatically install mpv, webtorrent, dmenu, yay & notflix. Do you want to continue? " yn
    case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please type y or n ";;
esac
done

echo "Installing pkgs; mpv, yay, dmenu & webtorrent... "

# Grabbing pkgs from Arch repos, installs yay
sudo pacman -S mpv yay dmenu &&
    # Installs from AUR
    yay -S webtorrent-cli &&
	echo "Packages installed!
	    Now fetching mpv.conf & installing... " &
		sleep 3s && echo "Done! Automatically installing notflix... "

# Fetching mpv.conf from my dotfiles repo
sudo curl -sL "https://gitlab.com/ayylmaonade/dotfiles/-/raw/main/config/mpv.conf" -o ~/.config/mpv/mpv.conf

# Installing notflix
sudo curl -sL "https://raw.githubusercontent.com/ayylmaonade/notflix/master/notflix" -o /usr/local/bin/notflix && chmod +x /usr/local/bin/notflix

echo "Installation complete! Run 'notflix' to use the script!"
