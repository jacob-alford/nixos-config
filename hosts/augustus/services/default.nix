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

  environment.etc."sysctl.d/99-tailscale.conf".text = ''
    net.ipv4.ip_forward = 1
    net.ipv6.conf.all.forwarding = 1
  '';

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
