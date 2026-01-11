{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    ./step-ca.nix
  ];

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
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
