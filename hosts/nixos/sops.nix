{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  sops.defaultSopsFile = ../../secrets/nixos.yaml;
  sops.age.keyFile = "/home/jacob/.config/sops/age/keys.txt";
  sops.secrets.smb_passphrase = {
    owner = "root";
  };
  sops.secrets.minecraft_backup_passphrase = {
    owner = "restic";
  };
  sops.templates."smb-creds" = {
    content = ''
      username=nixos
      password=${config.sops.placeholder.smb_passphrase}
    '';
    owner = "root";
  };
  sops.templates."minecraft-backup-passphrase" = {
    content = config.sops.placeholder.minecraft_backup_passphrase;
    owner = "restic";
  };
}
