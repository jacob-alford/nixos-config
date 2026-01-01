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
}
