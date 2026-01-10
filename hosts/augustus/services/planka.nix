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
  projectBackgroundImages = "${plankaDir}/background-images";
  attachments = "${plankaDir}/attachments";
  favicons = "${plankaDir}/favicons";

  plankaUserName = clientId;
  plankaDbName = plankaUserName;

  plankaAdminRole = "admin";
  plankaPORole = "project_owner";
  plankaUserRole = "board_user";

  containerPlankaSecretKeyFile = "/run/secrets/planka-secret-key";
  containerPlankaOIDCClientSecretFile = "/run/secrets/oidc-client-secret";
  containerPlankaDefaultAdminFile = "/run/secrets/planka-default-admin-password";

  caCert = config.environment.etc."ssl/certs/ca-certificates.crt".source;
in
{
  services.kanidm.provision.systems.oauth2."${clientId}" = {
    originUrl = "${domain}/oidc-callback";
    originLanding = "${domain}/";
    displayName = "Planka";

    # Planka doesn't appear to support the client code-challenge :(
    allowInsecureClientDisablePkce = true;

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
    plankaDbName
  ];

  services.postgresql.ensureUsers = [
    {
      name = plankaUserName;
      ensureDBOwnership = true;
    }
  ];

  virtualisation.quadlet.containers.planka.containerConfig = {
    image = "ghcr.io/plankanban/planka:2.0.0-rc.4";

    user = config.users.users.planka.name;

    userns = "keep-id:uid=${toString config.users.users.planka.uid},gid=${toString config.users.groups.planka.gid}";

    autoSubUidGidRange = true;

    # podman.sdnotify = "healthy";

    # autoRemoveOnStop = false;

    entrypoint = "./patched-start.sh";

    networks = [ "host" ];

    # podmanArgs = [
    #   "--health-cmd=node ./healthcheck.js"
    #   "--health-startup-interval=10s"
    #   "--health-startup-timeout=2s"
    #   "--health-start-period=15s"
    #   "--health-on-failure=stop"
    # ];

    volumes = [
      "${./planka-start.sh}:/app/patched-start.sh"
      "${favicons}:/app/public/favicons"
      "${userAvatars}:/app/public/user-avatars"
      "${projectBackgroundImages}:/app/public/background-images"
      "${attachments}:/app/private/attachments"
      "${caCert}:/data/ca.pem"
      "/run/postgresql:/run/postgresql"
      "${config.sops.secrets.planka_secret_key.path}:${containerPlankaSecretKeyFile}:ro"
      "${config.sops.templates."planka-client-secret".path}:${containerPlankaOIDCClientSecretFile}:ro"
      "${config.sops.secrets.planka_default_admin_pass.path}:${containerPlankaDefaultAdminFile}:ro"
    ];

    environments = {
      SHOW_DETAILED_AUTH_ERRORS = "true";

      DEFAULT_LANGUAGE = "en-US";
      DEFAULT_ADMIN_EMAIL = "planka-admin@a.plato-splunk.media";
      DEFAULT_ADMIN_PASSWORD__FILE = containerPlankaDefaultAdminFile;
      DEFAULT_ADMIN_NAME = "Plato Splunk Admin";
      DEFAULT_ADMIN_USERNAME = "admin";

      REQUESTS_CA_BUNDLE = "/data/ca.pem";
      NODE_EXTRA_CA_CERTS = "/data/ca.pem";

      BASE_URL = domain;
      TRUST_PROXY = "true";
      DATABASE_URL = "postgresql://planka@/planka?host=/run/postgresql";
      SECRET_KEY__FILE = containerPlankaSecretKeyFile;

      OIDC_ISSUER = "https://idm.plato-splunk.media/oauth2/openid/${clientId}";
      OIDC_CLIENT_ID = clientId;
      OIDC_CLIENT_SECRET__FILE = containerPlankaOIDCClientSecretFile;
      OIDC_ID_TOKEN_SIGNED_RESPONSE_ALG = "ES256";

      OIDC_ADMIN_ROLES = plankaAdminRole;
      OIDC_PROJECT_OWNER_ROLES = plankaPORole;
      OIDC_BOARD_USER_ROLES = plankaUserRole;
      OIDC_CLAIMS_SOURCE = "id_token";
      OIDC_IGNORE_USERNAME = "true";
      OIDC_ENFORCED = "true";
      OIDC_ROLES_ATTRIBUTE = "roles";
    };

    # autoStart = true;
  };

  services.caddy.virtualHosts."${domain}" = {
    extraConfig = ''
      reverse_proxy localhost:${builtins.toString port}
    '';
  };

  services.restic.backups.planka = {
    user = "restic";
    repository = "/mnt/backups/planka";
    initialize = true;
    passwordFile = config.sops.secrets.planka_restic_backup_passphrase.path;
    paths = [ plankaDir ];
    timerConfig = {
      OnCalendar = "Mon..Sun *-*-* 23:30:00";
      Persistent = true;
    };
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';
  };
}
