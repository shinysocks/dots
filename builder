#!/bin/bash

# update and install necessary packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install build-essential git curl cmake

mkdir projects sync

# install homebrew

# copy stuff from dots repo
cd projects
git clone https://github.com/shinysocks/dots
cd dots

# source bash config in bashrc
echo >> ~/.bashrc
echo "source ~/projects/dots/bash" >> ~/.bashrc

# install homebrew

