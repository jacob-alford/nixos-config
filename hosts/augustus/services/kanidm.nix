{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  domain = "idm.plato-splunk.media";
  ldapDomain = "ldap.plato-splunk.media";
  inherit (config.security.acme.certs."${domain}") directory;
in
{
  services.kanidm = {
    package = pkgs.kanidm.override { enableSecretProvisioning = true; };

    enableClient = true;
    clientSettings.uri = config.services.kanidm.serverSettings.origin;

    enableServer = true;
    serverSettings = {
      inherit domain;
      origin = "https://${domain}";
      trust_x_forward_for = true;
      ldapbindaddress = "127.0.0.1:636";
      bindaddress = "127.0.0.1:8443";

      tls_key = "${directory}/key.pem";
      tls_chain = "${directory}/fullchain.pem";
    };

    provision = {
      adminPasswordFile = config.sops.secrets.kanidm_admin_passphrase.path;
      idmAdminPasswordFile = config.sops.secrets.kanidm_idm_admin_passphrase.path;

      enable = true;
      autoRemove = true;

      groups = {
        "radius_users" = { };

        "openwebui_admins" = { };
        "openwebui_users" = { };

        "nextcloud_admins" = { };
        "nextcloud_users" = { };

        "jellyfin_admins" = { };
        "jellyfin_users" = { };
      };

      persons = {
        jacob = {
          displayName = "Jacob Alford";
          mailAddresses = [ "web@jacob-alford.dev" ];
          groups = [
            "radius_users"
            "openwebui_admins"
            "openwebui_users"
            "nextcloud_admins"
            "nextcloud_users"
            "jellyfin_admins"
            "jellyfin_users"
          ];
        };
      };
    };
  };

  services.caddy.virtualHosts."https://${domain}" = {
    extraConfig = ''
      tls "${directory}/fullchain.pem" "${directory}/key.pem"
      reverse_proxy ${config.services.kanidm.provision.instanceUrl} {
        header_up HOST {host}
        transport http {
          tls_server_name ${domain}
        }
      }
    '';
  };

  # ACME forwarders

  services.caddy.virtualHosts."http://${domain}" = {
    extraConfig = ''
      reverse_proxy localhost:1360
    '';
  };

  services.caddy.virtualHosts."http://${ldapDomain}" = {
    extraConfig = ''
      reverse_proxy localhost:1360
    '';
  };

  users.groups.idm.members = [ "caddy" "kanidm" ];

  security.acme.certs."${domain}" = {
    inherit domain;
    server = "https://ca.plato-splunk.media/acme/acme/directory";
    group = "idm";
    reloadServices = [ "caddy.service" "kanidm.service" ];
  };
}
