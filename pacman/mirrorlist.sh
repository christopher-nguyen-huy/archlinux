#! /usr/bin/env bash

# https://wiki.archlinux.org/index.php/Mirrors#List_by_speed

# Backup stock mirrorlist
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Download, clean and sort
curl "https://archlinux.org/mirrorlist/?protocol=https&ip_version=4&country=US&country=CA" | sed -e 's/^#Server/Server/g' -e '/^#/d' | rankmirrors -n 6 - > mirrorlist

mv mirrorlist /etc/pacman.d/mirrorlist

# update the Pacman package repository cache 
pacman -Syy
