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
  acmePort = 41872;
  domain = cfg.tlsDomain;
  inherit (config.security.acme.certs."${domain}") directory;
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
      default = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
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

    tlsDomain = lib.mkOption {
      type = lib.types.str;
      description = "The domain for the Postgres server's TLS cert";
    };

    provisionPasswords = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Attribute set of username to password file path for provisioning user passwords";
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

          # Listen on all interfaces for TCP connections
          listen_addresses = lib.mkForce "0.0.0.0,::";

          # Security defaults
          log_connections = true;
          log_statement = "all";
          logging_collector = true;
          log_disconnections = true;
          log_destination = lib.mkForce "syslog";

          # TLS configuration
          ssl = true;
          ssl_cert_file = "/run/credentials/postgresql.service/fullchain.pem";
          ssl_key_file = "/run/credentials/postgresql.service/key.pem";
          ssl_ca_file = "/run/credentials/postgresql.service/root-ca.pem";
        }
        cfg.additionalSettings
      ];

      identMap = ''
        # ArbitraryMapName systemUser          DBUser
          superuser_map      root                postgres
          superuser_map      postgres            postgres
        # Let other names login as themselves
          superuser_map      /^(.*)$             \1
        # Map certificate CN (subdomain.domain.tld) to subdomain username
          cert_map           /^([^.]+)\.plato-splunk\.media$  \1
      '';

      authentication = lib.mkForce ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD   OPTIONS

        # "local" is for Unix domain socket connections only
        # Superuser access for trusted users
          local   all             postgres                                peer     map=superuser_map
        # Other users restricted to their own database via peer authentication
          local   sameuser        all                                     peer     map=superuser_map

        # Network connections with SSL required
        # Password authentication over SSL for localhost:
          hostssl sameuser        all             127.0.0.1/32            scram-sha-256
          hostssl sameuser        all             ::1/128                 scram-sha-256
        # Client certificate authentication over SSL for remote:
          hostssl sameuser        all             0.0.0.0/0               cert     map=cert_map
          hostssl sameuser        all             ::/0                    cert     map=cert_map

        # Allow replication connections from localhost, by a user with the
        # replication privilege.
        #  local   replication     all                                     trust
        #  hostssl replication     all             127.0.0.1/32            cert
        #  hostssl replication     all             ::1/128                 cert
      '';
    };

    # Provision user passwords
    systemd.services.postgresql-provision-passwords = lib.mkIf (cfg.enable && cfg.provisionPasswords != { }) {
      description = "Provision PostgreSQL user passwords";
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
      };

      script = lib.concatStringsSep "\n" (lib.mapAttrsToList (user: passwordFile: ''
        password=$(cat ${passwordFile})
        ${config.services.postgresql.package}/bin/psql -c "ALTER USER ${user} WITH PASSWORD '$password';"
      '') cfg.provisionPasswords);
    };

    systemd.services.postgresql = lib.mkIf cfg.enable {
      serviceConfig = {
        LoadCredential = [
          "fullchain.pem:${directory}/fullchain.pem"
          "key.pem:${directory}/key.pem"
          "chain.pem:${directory}/chain.pem"
          "root-ca.pem:/etc/ssl/certs/ca-certificates.crt"
        ];
      };
    };

    services.postgresqlBackup = lib.mkIf cfg.enableBackup {
      enable = true;
      backupAll = true;
      location = cfg.backupLocation;
    };

    # ACME forwarder for postgres certificate
    services.caddy.virtualHosts."http://${domain}" = lib.mkIf cfg.enable {
      extraConfig = ''
        reverse_proxy localhost:${builtins.toString acmePort}
      '';
    };

    users.groups.postgres-certs = lib.mkIf cfg.enable {
      members = [ "postgres" ];
    };

    security.acme.certs."${domain}" = lib.mkIf cfg.enable {
      inherit domain;
      listenHTTP = "127.0.0.1:${builtins.toString acmePort}";
      server = "https://ca.plato-splunk.media/acme/acme/directory";
      group = "postgres-certs";
      reloadServices = [ "postgresql.service" ];
    };
  };
}
