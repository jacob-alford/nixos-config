{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "web@jacob-alford.dev";
    defaults.server = "https://ca.plato-splunk.media/acme/acme/directory";
    defaults.webroot = "/var/lib/acme/.challenges";
  };
}
