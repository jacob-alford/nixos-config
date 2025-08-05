{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./services
    ./filesystems.nix
    ./hardware.nix
    ./programs.nix
    ./security.nix
    ./sops.nix
    ./system.nix
    ./users.nix
  ];

  nixpkgs = {
    overlays = [
      ### Ollama Patch to use CUDA ###
      (self: super: {
        ctranslate2 = super.ctranslate2.override {
          withCUDA = true;
          withCuDNN = true;
        };
      })
    ];
    
    config = {
      allowUnfree = true;

      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "1password-gui"
          "1password"
        ];
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        # flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        # nix-path = config.nix.nixPath;

        allowed-users = [ "@wheel" ];
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Optimization

      optimise = {
        automatic = true;
        dates = [ "03:00" ];
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      jacob = import ../../home/jacob-nixos;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
