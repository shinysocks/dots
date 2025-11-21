{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitchExternalPower = "ignore";

  networking.hostName = "shinybox";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    inter
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox"; # ladybird soon!
    PROMPT_DIRTRIM = 2;
    PATH = "$HOME/projects/dots/scripts/:$PATH";
  };

  programs.bash = {
    shellAliases = {
      ".." = "cd ..";
      rsync = "rsync -azP --delete $HOME/sync/ shinysocks@pie:$HOME/sync/";
      recentsongs = "ls -ht $HOME/sync/tunes | head -n 30";
    };
    promptInit = ''
      l=$(tput setaf 5 bold);b=$(tput dim setaf 4 bold);r=$(tput sgr0);g=$(tput bold setaf 2);
      export PS1="\[$l\][\[$b\] \w \[$r$l\]] \[$g\]\$ \[$r\]";
    '';

    interactiveShellInit = ". $HOME/projects/dots/src/bash";
  };

  users.users.shinysocks = {
    shell = pkgs.bash;
    isNormalUser = true;
    description = "shinysocks";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      tree-sitter
      nodejs
      zip
      unzip
      firefox
      neovim
      git
      bash
      aria2
      btop
      calc
      croc
      dos2unix
      entr
      fd
      fzf
      gcc
      gdb
      gradle
      imagemagick
      bat
      shellcheck
      gum
      hey
      jq
      marp-cli
      mpv
      ncdu
      nmap
      pandoc
      pwgen
      qrencode
      ripgrep
      rsync
      tectonic
      tldr
      tree
      uv
      wget
      curl
      python3
      kitty
      openjdk
      signal-cli
      vscode-langservers-extracted
      lua-language-server
      typescript-language-server
      kotlin-language-server
      alejandra
      yt-dlp
      cron
      libheif
      gnumake
      gnutar
      nettools
      openssl
      procps
      ladybird
      feh
      dmenu
      flameshot
      rust-analyzer
      cargo
      alsa-utils
      bluetui
      bluez
    ];
  };

  programs.steam.enable = true;
  programs.nix-ld.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    windowManager.i3.enable = true;
    displayManager.startx.enable = true;
    desktopManager.xterm.enable = false;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -g 'this machine kills facists' --remember --time --asterisks --cmd 'startx'";
        user = "greeter";
      };
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  services.printing.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "11:00";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
