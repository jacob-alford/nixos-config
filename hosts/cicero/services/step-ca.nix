{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  domain = "ca.plato-splunk.media";
  postgresHost = "postgres-augustus.plato-splunk.media";
  clientId = "step-ca";

  rootCert = ../../certs/alford-root.crt;
  intermediateCert = ../../certs/intermediate_ca_2.crt;

  dbClientCert = "/var/lib/step-ca/certs/db-client.crt";
  dbClientKey = "/var/lib/step-ca/certs/db-client.key";
in
{
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 443;
    openFirewall = false;
    intermediatePasswordFile = config.sops.secrets.intermediate_crt_password.path;

    settings = {
      root = rootCert;
      crt = intermediateCert;
      key = "yubikey:slot-id=9c";

      insecureAddress = "";

      dnsNames = [ domain ];

      kms = {
        type = "yubikey";
        pin-source = config.sops.secrets.yk_pin.path;
      };

      logger = {
        format = "text";
      };

      db = {
        type = "postgresql";
        dataSource = "postgresql:///step-ca?host=${postgresHost}&sslmode=verify-full&sslcert=${dbClientCert}&sslkey=${dbClientKey}&sslrootcert=${rootCert}";
      };

      ssh = {
        hostKey = "yubikey:slot-id=82";
        userKey = "yubikey:slot-id=92";
      };

      authority = {
        policy = {
          x509 = {
            allow = {
              dns = [ "*.plato-splunk.media" ];
            };
            allowWildcardNames = false;
          };
          ssh = {
            host = {
              allow = {
                dns = [ "*.plato-splunk.media" ];
              };
            };
            user = {
              allow = {
                email = [ "@plato-splunk.media" ];
              };
              deny = {
                email = [ "postgres@plato-splunk.media" "root@plato-splunk.media" ];
              };
            };
          };
        };
        provisioners = [
          {
            type = "ACME";
            name = "acme";
            forceCN = true;
            challenges = [
              "http-01"
              "dns-01"
              "tls-alpn-01"
              "device-attest-01"
            ];
            claims = {
              enableSSHCA = true;
              disableRenewal = false;
              allowRenewalAfterExpiry = false;
              disableSmallstepExtensions = false;
            };
            options = {
              x509 = { };
              ssh = { };
            };
          }
          {
            type = "SSHPOP";
            name = "sshpop";
            claims = {
              enableSSHCA = true;
            };
          }
          {
            type = "OIDC";
            name = "kanidm";
            clientID = clientId;
            # Client Secret is "public" anywho
            # https://smallstep.com/docs/step-ca/provisioners/#notes
            clientSecret = config.sops.secrets.step_ca_oidc_client_secret.source;
            listenAddress = "localhost:60859";
            configurationEndpoint = "https://idm.plato-splunk.media/oauth2/openid/${clientId}/.well-known/openid-configuration";
            domains = [ "plato-splunk.media" ];
            claims = {
              enableSSHCA = true;
            };
          }
        ];
        template = { };
        backdate = "1m0s";
      };

      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };

      commonName = "Step Online CA";
    };
  };

  # Environment variables for PostgreSQL mTLS connection
  systemd.services.step-ca.environment = {
    STEPPATH = "/var/lib/step-ca";
    PGSSLCERT = dbClientCert;
    PGSSLKEY = dbClientKey;
    PGSSLROOTCERT = toString rootCert;
    PGSSLMODE = "verify-full";
    OIDC_CLIENT_SECRET = config.sops.secrets.step_ca_oidc_client_secret.path;
  };
}
