{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  cfg = config.services.ssh-cert-renewer;
in
{
  options.services.ssh-cert-renewer = {
    enable = lib.mkEnableOption "SSH certificate renewal service";

    sshKeyName = lib.mkOption {
      type = lib.types.str;
      description = "Name of the SSH key (without extension)";
    };

    certificateDomain = lib.mkOption {
      type = lib.types.str;
      description = "Domain name for the SSH certificate";
    };

    kanidmInstanceUrl = lib.mkOption {
      type = lib.types.str;
      description = "URL of the Kanidm instance";
    };

    serviceAccountName = lib.mkOption {
      type = lib.types.str;
      description = "Name of the Kanidm service account";
    };

    provisionerServiceAccount = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.serviceAccountName}_provisioner";
      description = "Name of the provisioner service account in Kanidm";
    };

    passwordFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to file containing the service account password";
    };

    keyDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/etc/ssh";
      description = "Directory where SSH keys are stored";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ssh-cert-renewer = {
      description = "SSH Certificate Renewal Service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStopPost = "${pkgs.systemd}/bin/systemctl try-restart sshd.service";
      };

      script = ''
        set -euo pipefail

        KEY_DIR="${cfg.keyDirectory}"
        KEY_NAME="${cfg.sshKeyName}"
        CERT_PUB="$KEY_DIR/$KEY_NAME-cert.pub"
        KEY_PUB="$KEY_DIR/$KEY_NAME.pub"
        KEY_PRIV="$KEY_DIR/$KEY_NAME"
        CERT_DOMAIN="${cfg.certificateDomain}"
        KANIDM_URL="${cfg.kanidmInstanceUrl}"
        SERVICE_ACCOUNT="${cfg.serviceAccountName}"
        PROVISIONER_ACCOUNT="${cfg.provisionerServiceAccount}"
        PASSWORD=$(cat "${cfg.passwordFile}")

        echo "Checking SSH certificate expiration for $CERT_PUB"

        if ${pkgs.step-cli}/bin/step ssh needs-renewal "$CERT_PUB"; then
          echo "Certificate needs renewal - requesting new token"

          # Calculate expiration time (now + 1 hour)
          EXPIRY=$(${pkgs.coreutils}/bin/date -u -d "+1 hour" +%Y-%m-%dT%H:%M:%SZ)

          # Get new token from Kanidm
          TOKEN=$(${pkgs.kanidm}/bin/kanidm service-account api-token generate \
            --url "$KANIDM_URL" \
            --name "$PROVISIONER_ACCOUNT" \
            --password "$PASSWORD" \
            "$SERVICE_ACCOUNT" \
            "Renew SSH Host Cert" \
            "$EXPIRY")

          if [ -n "$TOKEN" ]; then
            echo "Token acquired, requesting certificate renewal"
            ${pkgs.step-cli}/bin/step ssh certificate "$CERT_DOMAIN" "$KEY_PRIV" \
              --host \
              --sign \
              --provisioner "kanidm" \
              --token "$TOKEN"
            echo "Certificate renewed successfully via token"
          else
            echo "Failed to acquire token" >&2
            exit 1
          fi
        else
          echo "Certificate still valid - performing standard renewal"
          ${pkgs.step-cli}/bin/step ssh renew "$CERT_PUB" "$KEY_PRIV" --force
          echo "Certificate renewed successfully via standard renewal"
        fi
      '';
    };

    systemd.timers.ssh-cert-renewer = {
      description = "Timer for SSH Certificate Renewal";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "ssh-cert-renewer.service";
      };
    };
  };
}
