# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # inputs._1password-shell-plugins.hmModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nixvim.homeManagerModules.nixvim
    ../../shared/programs/git.nix
    ../../shared/programs/nixvim.nix
    ../../shared/programs/vscode.nix
    ../../shared/programs/zsh.nix
    ./programs.nix
    ./theming.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "jacob";
    homeDirectory = "/home/jacob";
  };

  dconf = {
    enable = true;
  };

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
