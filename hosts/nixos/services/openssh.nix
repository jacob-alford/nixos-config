{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
