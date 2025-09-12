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

  users.groups.idm.members = [ "caddy" "kanidm" ];


  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      80
      443
    ];
  };
}
