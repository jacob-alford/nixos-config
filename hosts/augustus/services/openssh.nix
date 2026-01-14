{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  sshKeyName = "ssh_host_ed25519";
in
{
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "jacob" ];
      TrustedUserCAKeys = "${../../../certs/ssh_user_ca_key.pub}";
    };
    hostKeys = [
      {
        type = "ed25519";
        path = "/etc/ssh/${sshKeyName}";
      }
    ];
    extraConfig = ''
      HostCertificate /etc/ssh/${sshKeyName}-cert.pub
    '';
  };

  services.ssh-cert-renewer = {
    inherit sshKeyName;
    enable = true;
    certificateDomain = "augustus.plato-splunk.media";
    kanidmInstanceUrl = "https://idm.plato-splunk.media";
    serviceAccountName = "step_ssh_host_augustus";
    passwordFile = config.sops.secrets.step_ca_ssh_host_augustus_provisioner_passphrase.path;
  };
}
