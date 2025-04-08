#!/bin/bash -i



#### update and install necessary packages ####
# sudo apt-get update -y
# sudo apt-get upgrade -y
# sudo apt install build-essential git curl cmake 
###############################################



dots_url="https://github.com/shinysocks/dots"

echo "making [~/projects], [~/.config/nvim], [~/.config/kitty]"
mkdir -p ~/projects ~/.config/nvim ~/.config/kitty

cd ~/projects/
git clone $dots_url || exit 1

cd dots

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# link configs from dots/
ln init.lua ~/.config/nvim/init.lua
ln kitty.conf ~/.config/kitty/kitty.conf
ln gitconfig ~/.gitconfig

# source bash config in bashrc
echo >> ~/.bashrc
echo "source ~/projects/dots/bash" >> ~/.bashrc

source ~/.bashrc

# tap for sdkman packages
/home/linuxbrew/.linuxbrew/bin/brew tap sdkman/tap

# install packages
/home/linuxbrew/.linuxbrew/bin/brew install $(cat brewlist)

# start syncthing
/home/linuxbrew/.linuxbrew/bin/brew services start syncthing
rm -rf ~/Sync

# install spotdl
python3 -m pip install spotdl --break-system-packages

# alert to complete syncthing setup
echo "TODO:"
echo "  sdkman post setup"
echo "  source ~/.bashrc"
echo "  complete syncthing setup: http://localhost:8384"
echo "  link bash.history from syncthing"
echo "  link .git-credentials from syncthing"


