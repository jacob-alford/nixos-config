{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
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
