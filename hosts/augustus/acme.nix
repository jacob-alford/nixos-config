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
  };
}
