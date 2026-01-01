{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [ ];

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "jacob" ];
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
