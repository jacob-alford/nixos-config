{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  # For gnome
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

  services.udev.packages = with pkgs; [
    via
    qmk-udev-rules
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    vim
    geekbench
    git
    git-credential-manager
    mangohud
    starship
    zsh
    via
    quickemu
    adwaita-icon-theme
    openssl
    # CIFS (SMB) client
    cifs-utils
    # Backups
    restic
  ];
}
