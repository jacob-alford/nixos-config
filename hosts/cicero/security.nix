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

    interfaces = {
      tailscale0 = {
        allowedTCPPorts = [ 22 ];
      };
    };
  };
}
