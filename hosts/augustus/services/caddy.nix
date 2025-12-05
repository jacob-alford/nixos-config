{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  services.caddy = {
    package = pkgs-unstable.caddy.withPlugins {
      plugins = [
        "github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc"
        # Doesn't currently support 2.10.2
        # "github.com/mholt/caddy-l4@v0.0.0-20250829174953-ad3e83c51edb"
      ];
      hash = "sha256-vH3Y5gFAKsCll2Wq3jxQCMWT4G0OwHSGn94y5/eP7zw=";
    };

    enable = true;
    email = "web@jacob-alford.dev";
    acmeCA = "https://ca.plato-splunk.media/acme/acme/directory";
  };
}
