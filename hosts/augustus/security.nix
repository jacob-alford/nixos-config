{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  security.sudo.execWheelOnly = true;

  security.pki.certificateFiles = [ ../../certs/alford-root.crt ];


  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      80
      443
    ];
  };
}
