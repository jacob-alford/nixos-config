{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
let
  caddyMod = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc"
      "github.com/mholt/caddy-l4@v0.0.0-20250530154005-4d3c80e89c5f"
    ];
    hash = "sha256-aGscfJ118kHyeWio5mwJQgieSiurG0mP3w/bJ+yn2us=";
  };
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    caddyMod
    pkgs.step-ca
    pkgs.step-cli
  ];

  launchd.user.agents.caddy = {
    command = "${caddyMod}/bin/caddy run --config /etc/nix-darwin/Caddyfile --envfile=\"${config.sops.templates."tailscale.env".path}\"";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/Users/jacob/Documents/caddy_jacob.out.log";
      StandardErrorPath = "/Users/jacob/Documents/caddy_jacob.err.log";
    };
  };

  launchd.daemons.step = {
    command = "${pkgs.step-ca}/bin/step-ca /etc/step/config/ca.json";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/etc/step/logs/step.out.log";
      StandardErrorPath = "/etc/step/logs/step.err.log";
      UserName = "_step";
    };
  };
}
