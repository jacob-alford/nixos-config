{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  sops.defaultSopsFile = ../../secrets/augustus.yaml;
  sops.age.keyFile = "/home/jacob/.config/sops/age/keys.txt";

  sops.secrets.kanidm_admin_passphrase = {
    owner = "kanidm";
    group = "kanidm";
  };

  sops.secrets.kanidm_idm_admin_passphrase = {
    owner = "kanidm";
    group = "kanidm";
  };

  sops.secrets.kanidm_restic_backup_passphrase = {
    owner = "restic";
  };

  sops.templates."kanidm-backup-passphrase" = {
    content = config.sops.placeholder.kanidm_restic_backup_passphrase;
    owner = "restic";
  };

  sops.secrets.openwebui_client_secret = {
    owner = "kanidm";
  };

  sops.secrets.home_assistant_client_secret = {
    owner = "kanidm";
  };

  sops.secrets.home_assistant_lat = {
    owner = "hass";
  };

  sops.secrets.home_assistant_long = {
    owner = "hass";
  };

  sops.secrets.unifi_radius_secret = {
    owner = "radiusd";
    group = "radiusd";
  };

  sops.secrets.ui_radius_auth_token = {
    owner = "radiusd";
    group = "radiusd";
  };

  sops.secrets.smb_passphrase = {
    owner = "root";
  };

  sops.templates."smb-creds" = {
    content = ''
      username=augustus
      password=${config.sops.placeholder.smb_passphrase}
    '';
    owner = "root";
  };
}
