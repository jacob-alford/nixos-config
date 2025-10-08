{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  domain = "https://dev-tools.plato-splunk.media";
  port = 47309;
in
{
  virtualisation.oci-containers.containers = {
    it-tools = {
      image = "corentinth/it-tools:latest";
      ports = [ "26257:${builtins.toString port}" ];
    };
  };

  services.caddy.virtualHosts."${domain}" = {
    extraConfig = ''
      reverse_proxy localhost:${builtins.toString port}
    '';
  };
}
