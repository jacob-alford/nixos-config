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
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      X11Forwarding = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "jacob" ];
    };
  };

  programs.ssh = {
    startAgent = true;
  };
}
