{ inputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  home.packages = with pkgs; [
    steam
    protonup-ng
    kitty
    prismlauncher
    discord
    makemkv
    protonvpn-gui
    bolt-launcher
    mullvad-browser
    yubikey-manager
    finamp
    freecad-wayland
    httpie
    dmidecode
    popsicle
    google-fonts
    inputs.affinity-nix.packages.x86_64-linux.photo
    inputs.affinity-nix.packages.x86_64-linux.designer
    inputs.affinity-nix.packages.x86_64-linux.publisher
    typst
    github-copilot-cli
    jq
  ];

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    font.name = "victor-mono";
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "victor-mono";
    };
  };

  programs.mangohud = {
    enable = true;
    settings = {
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_load_value = true;
      gpu_fan = true;

      cpu_temp = true;
      cpu_mhz = true;
      cpu_load_value = true;
    };
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "augustus.neko-bicolor.ts.net" = {
        user = "jacob";
        addKeysToAgent = "yes";
        forwardAgent = true;
        identityAgent = "/run/user/1000/ssh-agent";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "cicero.neko-bicolor.ts.net" = {
        user = "jacob";
        addKeysToAgent = "yes";
        forwardAgent = true;
        identityAgent = "/run/user/1000/ssh-agent";
        identityFile = "~/.ssh/id_ed25519_sk";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
    extraConfig = ''
      IdentitiesOnly yes
      IdentityAgent none
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
