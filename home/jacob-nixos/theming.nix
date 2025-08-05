{ inputs
, lib
, config
, pkgs
, ...
}: {
  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  gtk.catppuccin = {
    enable = true;
    flavor = "frappe";
    # gnomeShellTheme = true;
    icon = {
      enable = true;
      flavor = "frappe";
    };
  };
}
