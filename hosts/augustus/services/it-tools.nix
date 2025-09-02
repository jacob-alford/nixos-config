{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  config.virtualisation.oci-containers.containers = {
    it-tools = {
      image = "corentinth/it-tools:latest";
      ports = [ "26257:80" ];
    };
  };
}
