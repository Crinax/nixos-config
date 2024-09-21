# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  # Oh, experiment?
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.gfxmodeBios = "1920x1080";

  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "catppuccin-grub-theme";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "88f6124";
      hash = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY=";
    };
    installPhase = "cp -r src/catppuccin-mocha-grub-theme $out";
  };
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # xdg-portal settings
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal-gnome
  #   ];
  #   configPackages = [
  #     pkgs.xdg-desktop-portal-hyprland
  #   ];
  #   config.common.default = "*";
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     wireplumber.enable = true;
  };

  hardware.opengl.enable = true;

  # SDDM
  # services.displayManager.sddm.enable = true;

  # XServer
  # services.xserver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fert = {
    isNormalUser = true;
    home = "/home/fert";
    description = "fert";
    initialHashedPassword = "$y$j9T$1ZtBMK6wgswWWU7uf4slQ1$WBrQMxr01/s8ZNbWFgGi7JYRjKLWd7ZmAFz8Or.24FD";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  services.getty.autologinUser = "fert";
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  # Define default shell
  users.defaultUserShell = pkgs.zsh;

  # Fonts
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # Binabaash
  system.activationScripts.binbash = {
    deps = [ "binsh" ];
    text = ''
      ln -s /bin/sh /bin/bash
    '';
  };

  # ACME + nginx
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "crinax@yandex.ru";
  #
  # services.nginx = {
  #   enable = true;
  #   virtualHosts = {
  #     "crinax.org" = {
  #       forceSSL = true;
  #       enableACME = true;
  #       locations."/" = {
  #         root = "/var/www";
  #       };
  #     };
  #   };
  # };

  # Mailserver
  # services.maddy = {
  #   enable = true;
  #   primaryDomain = "localhost";
  #   ensureAccounts = [
  #     "no-reply@crinax.org"
  #   ];
  #   ensureCredentials = {
  #     "no-reply@crinax.org".passwordFile = "${pkgs.writeText "postmaster" "test"}";
  #   };
  # };

  # Mailclient
  # services.postfix = {
  #   enable = true;
  #   relayHost = "localhost";
  #   relayPort = 143;
  # };

  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    extundelete
    ext4magic
    wget
    prettierd
    eslint_d
    testdisk
    testdisk-qt
    opensmtpd
    git
    alacritty
    waybar
    wofi
    dunst
    tmux
    clipman
    swww
    wl-clipboard
    brave
    hyprcursor
    pavucontrol
    go
    nodejs_20
    yarn
    neovim
    clang
    hyprpicker
    waypaper
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    catppuccin-cursors.mochaDark
    hyprlang
    cairo
    librsvg
    libzip
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    grim
    kdePackages.qtwayland
    kdePackages.qt5compat
    kdePackages.qt6ct
    slurp
    python3
    python311Packages.pip
    thefuck
    unzip
    ripgrep
    lazygit
    gdu
    bottom
    bat
    eza
    zlib
    pkg-config
    glibc
    codeium
    neofetch
    yazi
    ueberzugpp
    openssl
    home-manager
    prisma-engines
    nodePackages.prisma
    pre-commit
    swappy
    qimgv
    translate-shell
    libreoffice
    gcc
    tmux
    postman
    godot_4
    firefox

    dbus
    openssl_3
    glib
    gtk3
    libsoup
    webkitgtk
    appimagekit

    gdk-pixbuf
    # (import ./corepack/default.nix pkgs)
    # (import ./rust/default.nix)
  ] ++ [
    (import ./prisma/prisma.nix)
  ];

  environment.variables.PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  environment.variables.PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  environment.variables.PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  
  environment.variables.LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.openssl ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # WARN: UNFREE packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "postman"
    "codeium"
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Hyprland
  programs.hyprland.enable = true;
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Docker
  virtualisation.docker = {
    enable = true;
  };
  
  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };

    histSize = 1000000;

    ohMyZsh = {
      enable = true;
      theme = "jonathan";
      plugins = [
        "git"
        "thefuck"
        "volta"
        "rust"
      ];
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

