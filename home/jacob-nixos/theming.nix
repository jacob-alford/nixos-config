{ inputs
, lib
, config
, pkgs
, ...
}: {
  catppuccin = {
    enable = true;
    flavor = "frappe";
    starship.enable = true;
    kitty.enable = true;
    ghostty.enable = true;
  };
}
