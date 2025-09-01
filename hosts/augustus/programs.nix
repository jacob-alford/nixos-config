{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
