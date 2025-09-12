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
        "alford.admins" = { };
        "alford.users" = { };
      };

      persons = {
        jacob = {
          displayName = "Jacob Alford";
          mailAddresses = [ "web@jacob-alford.dev" ];
          groups = [ "alford.admins" "alford.users" ];
        };
      };
    };
  };

  services.caddy.virtualHosts."${domain}" = {
    extraConfig = ''
      tls "${directory}/fullchain.pem" "${directory}/key.pem"
      reverse_proxy ${config.services.kanidm.provision.instanceUrl}
    '';
  };
}
