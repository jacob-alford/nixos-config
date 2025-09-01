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
  };
}
