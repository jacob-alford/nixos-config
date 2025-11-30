{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager.cosmic.enable = true;
}
