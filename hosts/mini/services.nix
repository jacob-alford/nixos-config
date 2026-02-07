{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.step-ca
    pkgs.step-cli
  ];

  launchd.daemons.caddy = {
    command = "${pkgs.caddy}/bin/caddy run --config ${./Caddyfile}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/Users/jacob/Documents/caddy_jacob.out.log";
      StandardErrorPath = "/Users/jacob/Documents/caddy_jacob.err.log";
    };
  };
}
