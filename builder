#!/bin/bash

# builder -> https://github.com/shinysocks/dots
cd ~/projects/dots

# update and install necessary packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install build-essential git curl cmake 

mkdir -p projects .config/nvim .config/kitty

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# link configs from dots/
ln init.lua ~/.config/nvim/init.lua
ln kitty.conf ~/.config/kitty/kitty.conf
ln gitconfig ~/.gitconfig

# install packages
brew install $(cat brewlist)

# start syncthing
brew services start syncthing
rm -rf ~/Sync

# source bash config in bashrc
echo >> ~/.bashrc
echo "source ~/projects/dots/bash" >> ~/.bashrc

# alert to complete syncthing setup
echo "complete syncthing setup: http://localhost:8384"

# copy bash history from syncthing

