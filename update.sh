#! /usr/bin/env bash

notify-send "Celestial Theme" "Getting the latest version of the Celestial theme..." -i system-software-update

# Cleanup old updates.
cd /tmp;
rm -Rf /tmp/celestial.zip 2>/dev/null
rm -Rf /tmp/celestial-gtk-theme-master/ 2>/dev/null

# Download latest version.
wget https://github.com/zquestz/celestial-gtk-theme/archive/master.zip -O celestial.zip

# Unzip downloaded file.
unzip celestial.zip;
cd celestial-gtk-theme-master

# Install updated theme.
./install.sh

notify-send "Celestial Theme" "All Done. Enjoy the latest version of the Celestial theme!" -i face-smile
