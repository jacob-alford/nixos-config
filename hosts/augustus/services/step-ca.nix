{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  clientId = "step-ca";
in
{
  # Provision OIDC client for step-ca in Kanidm
  services.kanidm.provision.systems.oauth2."${clientId}" = {
    originUrl = "http://localhost:60859/kanidm/callback";
    originLanding = "http://localhost:60859/";
    displayName = "Step CA";

    allowInsecureClientDisablePkce = false;

    basicSecretFile = config.sops.secrets.step_ca_oidc_client_secret.path;

    scopeMaps."step-ca.access" = [
      "openid"
      "email"
    ];
  };

  # Provision database for step-ca
  services.peesequel.ensureDatabases = [ "step-ca" ];

  services.peesequel.ensureUsers = [
    {
      name = "ca";
      ensureDBOwnership = true;
      ensureClauses = {
        database = "step-ca";
      };
    }
  ];
}
