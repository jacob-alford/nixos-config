{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    ./it-tools.nix
    ./caddy.nix
    ./kanidm.nix
    ./restic.nix
    ./openwebui.nix
    ./radius.nix
    ./home-assistant.nix
    ./postgres.nix
  ];

  services.getty.autologinUser = "jacob";

  services.tailscale.enable = true;

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
