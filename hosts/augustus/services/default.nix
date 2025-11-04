{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    ./quadlet.nix
    ./it-tools.nix
    ./caddy.nix
    ./kanidm.nix
    ./restic.nix
    ./openwebui.nix
    ./radius.nix
    ./home-assistant.nix
    ./postgres.nix
    ./planka.nix
    ./minecraft-servers
  ];

  services.getty.autologinUser = "jacob";

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "jacob" ];
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
