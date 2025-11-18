all: src/nix.nix
	alejandra -q src/nix.nix
	sudo nixos-rebuild switch

system:
	mkdir -p ~/projects ~/.config/nvim ~/.config/kitty ~/.config/i3
	rm -rf  ~/.config/i3/config ~/.config/nvim/init.lua ~/.config/kitty/kitty.conf
	sudo rm -rf /etc/nixos/configuration.nix
	echo "exec i3" > ~/.xinitrc
	ln src/i3.conf ~/.config/i3/config
	ln src/nvim.lua ~/.config/nvim/init.lua
	ln src/kitty.conf ~/.config/kitty/kitty.conf
	sudo ln src/nix.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
	ln src/gitconfig ~/.gitconfig
	echo "don't forget to copy sensitive files from ~/sync/recovery/makesystem/"
	ls "~/sync/recovery/makesystem/"

clean:
	nix-collect-garbage -d
	sudo nix-collect-garbage -d
