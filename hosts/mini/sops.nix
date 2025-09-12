{ inputs
, lib
, config
, pkgs
, ...
}: {
  sops.defaultSopsFile = ../../secrets/tailscale.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.age.keyFile = "Users/jacob/Library/Application\ Support/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets.jellyfin = {
    owner = "jacob";
  };
  sops.secrets.ai = {
    owner = "jacob";
  };
  sops.secrets."home-assistant" = {
    owner = "jacob";
  };
  sops.secrets.ollama = {
    owner = "jacob";
  };
  sops.secrets.affine = {
    owner = "jacob";
  };
  sops.secrets.umbrel = {
    owner = "jacob";
  };
  sops.secrets."dev-tools" = {
    owner = "jacob";
  };
  sops.secrets."ca" = {
    owner = "jacob";
  };

  sops.templates."tailscale.env" = {
    content = ''
      JELLYFIN_TS_KEY=${config.sops.placeholder."jellyfin"}
      OPENWEBUI_TS_KEY=${config.sops.placeholder."ai"}
      HOMEASSISTANT_TS_KEY=${config.sops.placeholder."home-assistant"}
      OLLAMA_TS_KEY=${config.sops.placeholder."ollama"}
      AFFINE_TS_KEY=${config.sops.placeholder."affine"}
      UMBREL_TS_KEY=${config.sops.placeholder."umbrel"}
      DEV_TOOLS_TS_KEY=${config.sops.placeholder."dev-tools"}
      CA_TS_KEY=${config.sops.placeholder."ca"}
    '';
    owner = "jacob";
  };
}
