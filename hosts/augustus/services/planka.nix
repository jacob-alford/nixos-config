{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  domain = "https://planka.plato-splunk.media";
  clientId = "planka";
  port = 1337;

  plankaDir = "/var/lib/planka";
  userAvatars = "${plankaDir}/user-avatars";
  projectBackgroundImages = "${plankaDir}/project-background-images";
  attachments = "${plankaDir}/attachments";

  plankaUserName = clientId;
  plankaDbName = plankaUserName;

  plankaAdminRole = "admin";
  plankaPORole = "project_owner";
  plankaUserRole = "board_user";

  containerDbPassFile = "/run/secrets/planka-database-password";
  containerPlankaSecretKeyFile = "/run/secrets/planka-secret-key";
  containerPlankaOIDCClientSecretFile = "/run/secrets/oidc-client-secret";

  caCert = config.environment.etc."ssl/certs/ca-certificates.crt".source;
in
{
  services.kanidm.provision.systems.oauth2."${clientId}" = {
    originUrl = "${domain}/oidc-callback";
    originLanding = "${domain}/";
    displayName = "Planka";

    # Planka doesn't appear to support the client code-challenge :(
    # allowInsecureClientDisablePkce = true;

    basicSecretFile = config.sops.secrets.planka_client_secret.path;

    scopeMaps."planka.access" = [
      "openid"
      "email"
      "profile"
    ];

    claimMaps.roles = {
      joinType = "array";
      valuesByGroup = {
        "planka.admins" = [ plankaAdminRole ];
        "planka.project_owner" = [ plankaPORole ];
        "planka.access" = [ plankaUserRole ];
      };
    };
  };

  services.postgresql.ensureDatabases = [
    plankaUserName
  ];

  services.postgresql.ensureUsers = [
    {
      name = plankaDbName;
      ensureDBOwnership = true;
    }
  ];

  virtualisation.oci-containers.containers.planka = {
    image = "ghcr.io/plankanban/planka:2.0.0-rc.4";

    user = "root";

    extraOptions = [
      "--network=host"
    ];

    volumes = [
      "${userAvatars}:/app/public/user-avatars"
      "${projectBackgroundImages}:/app/public/project-background-images"
      "${caCert}:/data/ca.pem"
      "${attachments}:/app/private/attachements"
      "${config.sops.secrets.planka_secret_key.path}:${containerPlankaSecretKeyFile}:ro"
      "${config.sops.secrets.planka_db_pass.path}:${containerDbPassFile}:ro"
      "${config.sops.secrets.planka_client_secret.path}:${containerPlankaOIDCClientSecretFile}:ro"
    ];

    environment = {
      REQUESTS_CA_BUNDLE = "/data/ca.pem";
      NODE_EXTRA_CA_CERTS = "/data/ca.pem";

      BASE_URL = domain;
      TRUST_PROXY = "1";
      DATABASE_URL = "postgresql://planka:$${DATABASE_PASSWORD}@127.0.0.1/planka";
      SECRET_KEY__FILE = containerPlankaSecretKeyFile;
      DATABASE_PASSWORD__FILE = containerDbPassFile;

      OIDC_ISSUER = "https://idm.plato-splunk.media/oauth2/openid/${clientId}";
      OIDC_CLIENT_ID = clientId;
      OIDC_CLIENT_SECRET__FILE = containerPlankaOIDCClientSecretFile;

      OIDC_ADMIN_ROLES = plankaAdminRole;
      OIDC_PROJECT_OWNER_ROLES = plankaPORole;
      OIDC_BOARD_USER_ROLES = plankaUserRole;
      OIDC_CLAIMS_SOURCE = "id_token";
      OIDC_IGNORE_USERNAME = "true";
      OIDC_ENFORCED = "true";
    };

    autoStart = true;
  };

  services.caddy.virtualHosts."${domain}" = {
    extraConfig = ''
      reverse_proxy localhost:${builtins.toString port}
    '';
  };
}
