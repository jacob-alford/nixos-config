{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  user = "postgres";
  package = pkgs.postgresql_17_jit;
  dataDir = "/var/lib/postgresql/${package.psqlSchema}";
in
{
  services.postgresql = {
    inherit package dataDir;

    enable = true;

    ensureDatabases = [
      "plato-splunk"
    ];

    ensureUsers = [
      {
        name = "plato-splunk";
        ensureDBOwnership = true;
      }
    ];

    settings = {
      port = 5432;
      max_connections = 100;

      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };

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
        local   all             all                                     peer     map=superuser_map
      # IPv4 local connections:
        host    all             all             127.0.0.1/32            trust
      # IPv6 local connections:
        host    all             all             ::1/128                 trust

      # Allow replication connections from localhost, by a user with the
      # replication privilege.
      #  local   replication     all                                     trust
      #  host    replication     all             127.0.0.1/32            trust
      #  host    replication     all             ::1/128                 trust

      # Other Remote Access - allow access only the database with the same name as the user
      #  host    sameuser        all             0.0.0.0/0               scram-sha-256
    '';
  };
}
