{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  catppuccin = {
    enable = true;
    flavor = "latte";
    starship.enable = true;
    kitty.enable = true;
    ghostty.enable = true;
  };
}
