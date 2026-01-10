{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  cfg = config.services.peesequel;
  inherit (cfg) package dataDir;
in
{
  options.services.peesequel = {
    enable = lib.mkEnableOption "PostgreSQL server with custom configuration";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_17_jit;
      description = "PostgreSQL package to use";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/postgresql/\${config.services.postgresql.package.psqlSchema}";
      description = "Data directory for PostgreSQL";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5432;
      description = "Port for PostgreSQL to listen on";
    };

    maxConnections = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "Maximum number of concurrent connections";
    };

    ensureDatabases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of databases to ensure exist";
    };

    ensureUsers = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "List of users to ensure exist";
    };

    enableBackup = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable PostgreSQL backups";
    };

    backupLocation = lib.mkOption {
      type = lib.types.str;
      default = "/var/backup/postgresql";
      description = "Location for PostgreSQL backups";
    };

    additionalSettings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional PostgreSQL settings";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      inherit package dataDir;
      enable = true;

      inherit (cfg) ensureDatabases ensureUsers;

      settings = lib.mkMerge [
        {
          port = cfg.port;
          max_connections = cfg.maxConnections;

          # Security defaults
          log_connections = true;
          log_statement = "all";
          logging_collector = true;
          log_disconnections = true;
          log_destination = lib.mkForce "syslog";
        }
        cfg.additionalSettings
      ];

      identMap = ''
        # ArbitraryMapName systemUser          DBUser
          superuser_map      root                postgres
          superuser_map      postgres            postgres
          superuser_map      jacob               postgres
        # Let other names login as themselves
          superuser_map      /^(.*)$             \1
      '';

      authentication = lib.mkForce ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD   OPTIONS

        # "local" is for Unix domain socket connections only
        # Superuser access for trusted users
          local   all             postgres                                peer     map=superuser_map
        # Other users restricted to their own database only
          local   sameuser        all                                     peer

        # Network connections disabled for security - use Unix sockets only
        # IPv4 local connections:
        #  host    all             all             127.0.0.1/32            trust
        # IPv6 local connections:
        #  host    all             all             ::1/128                 trust

        # Allow replication connections from localhost, by a user with the
        # replication privilege.
        #  local   replication     all                                     trust
        #  host    replication     all             127.0.0.1/32            trust
        #  host    replication     all             ::1/128                 trust

        # Other Remote Access - allow access only the database with the same name as the user
        #  host    sameuser        all             0.0.0.0/0               scram-sha-256
      '';
    };

    services.postgresqlBackup = lib.mkIf cfg.enableBackup {
      enable = true;
      backupAll = true;
      location = cfg.backupLocation;
    };
  };
}
