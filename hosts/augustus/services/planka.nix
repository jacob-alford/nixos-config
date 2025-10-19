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
  plankaDir = "/var/lib/planka";
  userAvatars = "${plankaDir}/user-avatars";
  projectBackgroundImages = "${plankaDir}/project-background-images";
  attachments = "${plankaDir}/attachments";
in
{
  services.kanidm.provision.systems.oauth2."${clientId}" = {
    originUrl = "${domain}/auth/oidc/callback";
    originLanding = "${domain}/";
    displayName = "Planka";

    basicSecretFile = config.sops.secrets.planka_client_secret.path;

    scopeMaps."planka.access" = [
      "openid"
      "email"
      "profile"
    ];

    claimMaps.groups = {
      joinType = "array";
      valuesByGroup = {
        "planka.admins" = [ "admin" ];
        "planka.project-owner" = [ "project-owner" ];
        "planka.access" = [ "board-user" ];
      };
    };
  };

  virtualisation.oci-containers.containers.planka = {
    image = "ghcr.io/plankanban/planka:latest";

    volumes = [
      "${userAvatars}:/app/public/user-avatars"
      "${projectBackgroundImages}:/app/public/project-background-images"
      "${attachments}:/app/private/attachements"
      "${config.sops.secrets.planka-secret-key.path}:/run/secrets/planka-secret-key:ro"
      "${config.sops.secrets.planka-database-password.path}:/run/secrets/planka-database-password:ro"
    ];

    environment = {
      BASE_URL = domain;
      TRUST_PROXY = "1";
      DATABASE_URL = "postgresql://planka_admin:$${DATABASE_PASSWORD}@transfigured-night/planka";
      SECRET_KEY__FILE = "/run/secrets/planka-secret-key";
      DATABASE_PASSWORD__FILE = "/run/secrets/planka-database-password";
    };

    autoStart = true;
  };
}
