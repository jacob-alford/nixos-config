{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  sops.defaultSopsFile = ../../secrets/cicero.yaml;
  sops.age.keyFile = "/home/jacob/.config/sops/age/keys.txt";

  sops.secrets.intermediate_crt_password = {
    owner = "step-ca";
    group = "step-ca";
  };

  sops.secrets.yk_pin = {
    owner = "step-ca";
    group = "step-ca";
  };

  sops.secrets.step_ca_oidc_client_secret = {
    owner = "step-ca";
    group = "step-ca";
  };

  sops.templates."step-ca-oidc-client-secret" = {
    content = config.sops.placeholder.step_ca_oidc_client_secret;
    owner = "step-ca";
    group = "step-ca";
  };
}
