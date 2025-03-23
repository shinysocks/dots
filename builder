#!/bin/bash

# update and install necessary packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install build-essential git curl cmake 

mkdir -p projects sync .config/nvim .config/kitty

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# copy stuff from dots repo
cd projects
git clone https://github.com/shinysocks/dots
cd dots
ln init.lua ~/.config/nvim/init.lua
ln kitty.conf ~/.config/kitty/kitty.conf

# source bash config in bashrc
echo >> ~/.bashrc
echo "source ~/projects/dots/bash" >> ~/.bashrc

