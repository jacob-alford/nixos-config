# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.sudo.execWheelOnly = true;

  security.pki.certificateFiles = [ ../certs/alford-root.crt ];

  networking.firewall = {
    enable = true;
    # PORT for Whisper and Pipe (Wyoming)
    allowedTCPPorts = [ 10300 10200 ];
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      # "--commit-lock-file"
    ];
    allowReboot = false;
  };

  networking.hostName = "nixos";

  services.tailscale.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

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

  services.xserver.enable = true;

  # services.displayManager.sddm = {
  #  enable = true;
  #  settings = {
  #    Theme.Font = "noto-sans-meetei-mayek";
  #  };
  #  wayland.enable = true;
  # };

  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    orca
    # evince
    # file-roller
    geary
    # gnome-disk-utility
    # seahorse
    # sushi
    # sysprof
    #
    # gnome-shell-extensions
    #
    # adwaita-icon-theme
    # nixos-background-info
    gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    # gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    # baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    # gnome-calendar
    # gnome-characters
    # gnome-clocks
    # gnome-console
    gnome-contacts
    # gnome-font-viewer
    # gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    # gnome-weather
    # loupe
    # nautilus
    # gnome-connections
    simple-scan
    # snapshot
    totem
    yelp
    # gnome-software
  ];

  #  services.desktopManager.plasma6 = {
  #    enable = true;
  # notoPackage = with pkgs; [
  #  helvetica-neue-lt-std
  # ];
  #  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ### Grahpics / Gaming ###

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # This breaks wayland if disabled
    modesetting.enable = true;

    # driSupport = true;
    # Results in artifacts when awaking from sleep
    powerManagement.enable = true;

    # Turns off GPU when not in use, maybe try with new GPU
    powerManagement.finegrained = false;

    # Must enable for 560+ driver version
    open = true;

    nvidiaSettings = false;

    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      # version = "570.133.07";
      # sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      # sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
      # openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      # settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      # persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";

      # version = "570.86.16";
      # sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      # sha256_aarch64 = "sha256-RiO2njJ+z0DYBo/1DKa9GmAjFgZFfQ1/1Ga+vXG87vA=";
      # openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      # settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      # persistencedSha256 = "sha256-3mp9X/oV8o2TH9720NnoXROxQ4g98nNee+DucXpQy3w=";

      # version = "575.51.02";
      # sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      # sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
      # openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      # settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      # persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";

      version = "575.64.03";
      sha256_64bit = "sha256-S7eqhgBLLtKZx9QwoGIsXJAyfOOspPbppTHUxB06DKA=";
      sha256_aarch64 = "sha256-s2Jm2wjdmXZ2hPewHhi6hmd+V1YQ+xmVxRWBt68mLUQ=";
      openSha256 = "sha256-SAl1+XH4ghz8iix95hcuJ/EVqt6ylyzFAao0mLeMmMI=";
      settingsSha256 = "sha256-o8rPAi/tohvHXcBV+ZwiApEQoq+ZLhCMyHzMxIADauI=";
      persistencedSha256 = "sha256-/3OAZx8iMxQLp1KD5evGXvp0nBvWriYapMwlMSc57h8=";
    };
  };

  ### Printing ###

  # disabling temporarily for recent CUPS vuln
  services.printing.enable = true;

  ### Yubikey Daemon ###
  services.pcscd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  ### Ollama ###

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs-unstable.ollama;

    openFirewall = true;

    host = "0.0.0.0";
  };

  ### Whisper Voice Recognition ###

  services.wyoming = {
    faster-whisper.servers = {
      home = {
        enable = true;
        uri = "tcp://0.0.0.0:10300";
        language = "en";
        device = "cuda";
        model = "distil-large-v3";
      };
    };

    piper = {
      servers.home = {
        enable = true;
        voice = "en_GB-southern_english_female-low";
        uri = "tcp://0.0.0.0:10200";
      };
    };
  };

  ### Minecraft ###
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    whitelist = {
      # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
      jacob_alford = "dfb56ab8-5441-4165-be4f-27f8e6e31ac4";
      Ryan_In_Reverie = "dab38f2e-0d4d-4c9f-8e4f-3fc1c23d9a42";
      squish37 = "3f66f523-9fb1-4fc9-af4a-1bdddcc50f9a";
    };
    serverProperties = {
      server-port = 25565;
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      motd = "§dThe Best§r§1 §r§5§kabcdefg§r§1 server§r";
      white-list = true;
      allow-cheats = false;
      enforce-whitelist = true;
    };
    package = pkgs.papermcServers.papermc-1_21_5;
  };

  #### Sound ####
  services.pulseaudio.enable = false;

  ### QMK / Keyboard ###
  hardware.keyboard.qmk.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #jack.enable = true; # JACK applications?

    #media-session.enable = true; # ?
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      (self: super: {
        ctranslate2 = super.ctranslate2.override {
          withCUDA = true;
          withCuDNN = true;
        };
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;

      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "1password-gui"
          "1password"
        ];
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        # flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        # nix-path = config.nix.nixPath;

        allowed-users = [ "@wheel" ];
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Optimization

      optimise = {
        automatic = true;
        dates = [ "03:00" ];
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # FIXME: Add the rest of your current configuration

  # For gnome :/
  programs.dconf.enable = true;

  programs.firefox.enable = true;

  programs.steam.enable = true;

  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  programs._1password.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jacob" ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    # neovim
    vim
    geekbench
    git
    git-credential-manager
    mangohud
    starship
    zsh
    via
    quickemu
    # kdePackages.partitionmanager
    # catppuccin-kde
    adwaita-icon-theme
    gnomeExtensions.appindicator
    openssl
    # CIFS (SMB) client
    cifs-utils
    # openai-whisper
    # piper-tts
  ];

  services.udev.packages = with pkgs; [
    via
    qmk-udev-rules
    gnome-settings-daemon
  ];

  fonts = {
    packages = with pkgs; [
      victor-mono
      noto-fonts
      noto-fonts-emoji
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        serif = [ "noto-serif" ];
        sansSerif = [ "noto-sans-meetei-mayek" ];
        monospace = [ "victor-mono" ];
      };
    };
  };

  sops.defaultSopsFile = ../secrets/nixos.yaml;
  sops.age.keyFile = "/home/jacob/.config/sops/age/keys.txt";
  sops.secrets.smb_passphrase = {
    owner = "root";
  };
  sops.templates."smb-creds" = {
    content = ''
      username=nixos
      password=${config.sops.placeholder.smb_passphrase}
    '';
    owner = "root";
  };

  fileSystems."/mnt/unas-nixos" = {
    device = "//10.10.0.251/Personal-Drive";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=${config.sops.templates."smb-creds".path},uid=${toString config.users.users.jacob.uid}" ];
  };

  ### Stylix ###

  # stylix.enable = true;

  # stylix.image = /home/jacob/Documents/plasma-workspace-wallpapers/ScarletTree/contents/images/5120x2880.png;

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  # NOTE: Git for whatever reason will override credential helpers if this is set
  # wth

  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
  '';

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      jacob = import ../home-manager/home.nix;
    };
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    jacob = {
      isNormalUser = true;
      description = "Jacob Alford";
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
      ];
      shell = pkgs.zsh;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  # services.openssh = {
  #  enable = true;
  #  settings = {
  # Opinionated: forbid root login through SSH.
  #    PermitRootLogin = "no";
  # Opinionated: use keys only.
  # Remove if you want to SSH using passwords
  #    PasswordAuthentication = false;
  #  };
  #};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
