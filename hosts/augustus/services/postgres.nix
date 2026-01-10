{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  services.peesequel = {
    enable = true;
    package = pkgs.postgresql_17_jit;
    enableBackup = true;

    ensureDatabases = [
      "plato-splunk"
    ];

    ensureUsers = [
      {
        name = "plato-splunk";
        ensureDBOwnership = true;
      }
    ];
  };

  # Backups
  services.restic.backups.postgres = {
    user = "restic";
    repository = "/mnt/backups/postgres";
    initialize = true;
    passwordFile = config.sops.templates."postgres-backup-passphrase".path;
    paths = [
      "${config.services.postgresqlBackup.location}/all.sql.gz"
    ];
    timerConfig = {
      OnCalendar = "Mon..Sun *-*-* 01:30:00";
      Persistent = true;
    };
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';
  };
}
