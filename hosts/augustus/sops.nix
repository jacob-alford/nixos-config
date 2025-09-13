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

  # sops.templates."smb-creds" = {
  #   content = ''
  #     username=nixos
  #     password=${config.sops.placeholder.smb_passphrase}
  #   '';
  #   owner = "root";
  # };
  # sops.templates."minecraft-backup-passphrase" = {
  #   content = config.sops.placeholder.minecraft_backup_passphrase;
  #   owner = "restic";
  # };
}
