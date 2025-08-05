{ inputs
, lib
, config
, pkgs
, self
, ...
}: {
  imports = [
    ../../shared/nix.nix
    ../../shared/programs/nixvim.nix
    ./programs.nix
    ./services.nix
    ./sops.nix
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "jacob";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    ];
}
