{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
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
    ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  # services
  services.openssh.enable = true;
  services.printing.enable = true;

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
