{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  inherit (config.security.acme.certs."idm.plato-splunk.media") directory;
in
{
  config.virtualisation.oci-containers.containers = {
    radiusd = {
      image = "kanidm/radius:latest";
      ports = [ "1812:1812" "1812:1812/udp" ];
      volumes = [
      ];
    };
  };

  sops.templates."radius_config" = {
    content = ''
      uri = "localhost:8443"
      verify_hostnames = true;
      verify_ca = true;

      auth_token = "${config.sops.placeholder.ui_radius_auth_token}"

      radius_default_vlan = 45

      radius_required_groups = ["radius.access@idm.plato-splunk.media"]

      radius_groups = [
        { spn = "radius.access_guest", vlan = 45 },
        { spn = "radius.access_home", vlan = 55 },
        { spn = "radius.access_private", vlan = 100 }
      ]

      radius_clients = [
        { name = "u6e", ipaddr = "10.10.0.121", secret = "${config.sops.placeholder.unifi_radius_secret}" }
      ]

      radius_ca_path = ""
    '';
  };
}
