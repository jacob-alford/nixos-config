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

  users.groups.sso.members = [ "caddy" "kanidm" ];

  security.acme.certs."idm.plato-splunk.media" = {
    domain = "idm.plato-splunk.media";
    extraDomainNames = [ "ldap.plato-splunk.media" ];
    group = "sso";
    reloadServices = [ "caddy.service" "kanidm.service" ];
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      443
    ];
  };
}
